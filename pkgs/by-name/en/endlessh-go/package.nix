{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "endlessh-go";
  version = "2025.0914.0";

  src = fetchFromGitHub {
    owner = "shizunge";
    repo = "endlessh-go";
    rev = version;
    hash = "sha256-ABrmvP8xfH1DWzepnzrIsNJDE9sDoXPQteA/ToyRtoo=";
  };

  vendorHash = "sha256-HumLc9u7jVFk7228SYHptBEOSRdLp4r5QECYlYrO6KY=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests = {
    inherit (nixosTests) endlessh-go;
  };

  meta = {
    description = "Implementation of endlessh exporting Prometheus metrics";
    homepage = "https://github.com/shizunge/endlessh-go";
    changelog = "https://github.com/shizunge/endlessh-go/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ azahi ];
    mainProgram = "endlessh-go";
  };
}
