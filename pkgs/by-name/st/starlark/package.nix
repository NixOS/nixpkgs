{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule {
  pname = "starlark";
  version = "0-unstable-2026-06-13";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "8ba36ccb83fb02b223182e27808a6d5d0636afb9";
    hash = "sha256-TH97v0LZt2W/0P9jPuKBmBCa079o3FIcX2hHBidhC3Y=";
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
