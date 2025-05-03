{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jxscout";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "francisconeves97";
    repo = "jxscout";
    tag = "v${version}";
    hash = "sha256-MMTMAdj+N0jgwWnSOoBSGCyGITugtAcK/4SQAMjUcaU=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to perform JavaScript analysis for security researchers";
    homepage = "https://github.com/francisconeves97/jxscout";
    changelog = "https://github.com/francisconeves97/jxscout/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "jxscout";
  };
}
