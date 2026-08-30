{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule {
  pname = "starlark";
  version = "0-unstable-2026-08-28";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "6dd8f160a37fc95b7099a2fdb535815b27e38ae9";
    hash = "sha256-lJ7UbX/OLYBNJnBYu7gTcXUhyWYt7yduxt7aiudz++I=";
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
