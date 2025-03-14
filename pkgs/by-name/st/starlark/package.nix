{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule {
  pname = "starlark";
  version = "0-unstable-2025-02-25";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "0d3f41d403af5d6607cdf241f12b7e0572f2cb58";
    hash = "sha256-ZZR89U2+LhzAptNz/S2qMBKNGdf5xUbXLcLCHizhQ2A=";
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
