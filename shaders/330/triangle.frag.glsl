#version 330 core

in vec3 position_eye;
in vec2 tex_coord;
in vec3 normal_eye;

uniform mat4 view_mat;
uniform mat4 model_mat;
uniform sampler2D tex;

uniform PointLight {
    vec3 La;
    vec3 Ld;
    vec3 Ls;
    float specular_exponent;
    vec3 pos_wor;
} light;

out vec4 frag_color;


void main() {
    vec3 K = vec3 (texture (tex, tex_coord));
    vec3 Ka = K;
    vec3 Kd = K;
    vec3 Ks = K;

    vec3 norm_eye = normalize (normal_eye);
    vec3 Ia = light.La * Ka;

    vec3 light_pos_eye = vec3 (view_mat * vec4 (light.pos_wor, 1.0));
    vec3 dist_to_light_eye = - position_eye - light_pos_eye;
    vec3 dir_to_light_eye = normalize (dist_to_light_eye);
    float dot_diffuse = max (dot (dir_to_light_eye, norm_eye), 0.0);
    vec3 Id = light.Ld * Kd * dot_diffuse;

    vec3 surface_to_viewer_eye = normalize (-position_eye);
    vec3 half_vec_eye = normalize (surface_to_viewer_eye + dir_to_light_eye);
    float dot_specular = max (dot (half_vec_eye, norm_eye), 0.0);
    float specular_factor = pow (dot_specular, light.specular_exponent);
    vec3 Is = light.Ls * Ks * specular_factor;

    frag_color = vec4(Ia + Id + Is, 1.0);
}
