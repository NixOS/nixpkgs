{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "goplantuml";
  version = "1.6.2";
  src = fetchFromGitHub {
    owner = "jfeliu007";
    repo = "goplantuml";
    tag = "v${version}";
    hash = "sha256-OnCAqws27e7WsXKmw0clH9Qek+6LNeu2UGD9sKaV4+I=";
  };
  vendorHash = null;
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
