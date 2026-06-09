{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule {
  pname = "starlark";
  version = "0-unstable-2026-05-22";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "ec58d4b459e2866ed51124596d888ed7aa4f90b8";
    hash = "sha256-9H0TIp2CIGo5Rqld9Xvsg/uQmfswiUzSsu7vwazjcho=";
  };

  vendorHash = "sha256-Ejw5f5ulEcLHm4WYKatwA7FZ9lfdqZTOE3SdkaK6jYE=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://github.com/google/starlark-go";
    description = "Interpreter for Starlark, implemented in Go";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "starlark";
  };
}
