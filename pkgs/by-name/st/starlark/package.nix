{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule {
  pname = "starlark";
  version = "0-unstable-2025-08-04";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "3c9dc17c5f2e062f7d7b8b4237e571810e9c6445";
    hash = "sha256-hNP2kt6X46WpyQ4eDFU+mGP4x5H6sD3PC+BRD3AUgbo=";
  };

  vendorHash = "sha256-8drlCBy+KROyqXzm/c+HBe/bMVOyvwRoLHxOApJhMfo=";

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
