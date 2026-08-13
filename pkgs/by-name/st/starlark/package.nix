{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule {
  pname = "starlark";
  version = "0-unstable-2026-07-08";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "5395d018f003e2a08bfbca6dcb2562acee700f62";
    hash = "sha256-g/f0g11vC9ScBuVYt/PRGSCyJApjq2m1hsFqUNUsZg4=";
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
