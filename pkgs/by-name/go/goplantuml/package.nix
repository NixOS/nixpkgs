{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "goplantuml";
  version = "1.6.3";
  src = fetchFromGitHub {
    owner = "jfeliu007";
    repo = "goplantuml";
    tag = "v${version}";
    hash = "sha256-+8RvifAYJv6cxIZ9sNKWNVhSNzUotGjjRjGynGqbO6o=";
  };
  vendorHash = "sha256-IVuhzjPGzPVKHpPdkX/GWItbKaz4PLyUFQAQ7RQO9/M=";
  meta = {
    changelog = "https://github.com/jfeliu007/goplantuml/releases/tag/v${version}";
    description = "PlantUML Class Diagram Generator for golang projects";
    homepage = "https://github.com/jfeliu007/goplantuml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matteobongio
    ];
    mainProgram = "goplantuml";
  };

}
