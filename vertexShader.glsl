const vertexShaderSource = `
#define GLSLIFY 1

attribute vec3 vertex;
attribute vec3 normal;
uniform mat4 normalMatrix;
uniform mat4 ModelViewProjectionMatrix;

uniform float shininess;
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;

uniform vec3 lightPosition;

varying vec4 color;

void main() {
    vec4 vertexPosition4 = ModelViewProjectionMatrix * vec4(vertex, 1.0);
    vec3 vertexPosition = vec3(vertexPosition4) / vertexPosition4.w;
    vec3 normalInterpolation = vec3(normalMatrix * vec4(normal, 0.0));
    gl_Position = vertexPosition4;
    
    vec3 normal = normalize(normalInterpolation);
    vec3 lightDirection = normalize(lightPosition - vertexPosition);
    
    float nDotLight = max(dot(normal, lightDirection), 0.0);
    float specularLight = 0.0;
    if (nDotLight > 0.0) {
        vec3 viewDirection = normalize(-vertexPosition);
        vec3 halfDirection = normalize(lightDirection + viewDirection);
        float specularAngle = max(dot(halfDirection, normal), 0.0);
        specularLight = pow(specularAngle, shininess);
    }
    vec3 diffuse = nDotLight * diffuseColor;
    vec3 ambient = ambientColor;
    vec3 specular = specularLight * specularColor;
    color = vec4(diffuse + ambient + specular, 1.0);
}`;