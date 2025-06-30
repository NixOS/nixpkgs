{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule {
  pname = "starlark";
  version = "0-unstable-2025-06-23";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "8bf495bf4e9a6110b82436cdebbdc3f06ad4f474";
    hash = "sha256-m8jWFPXYrT0kTbrz6xHi6Q7D5mzoycU+SY3h7SnCYiU=";
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
