{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule {
  pname = "starlark";
  version = "0-unstable-2024-11-19";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "d4d7611b175970714abca4efdc91692ee958a80f";
    hash = "sha256-1/nDuO7i9NVKUt5OSemQfE0TO78gvKBfHFoYC1u0VOQ=";
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
