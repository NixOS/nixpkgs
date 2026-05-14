{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule {
  pname = "starlark";
  version = "0-unstable-2026-03-26";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "fadfc96def35ea95e7f2bd9952256d4db1d80d91";
    hash = "sha256-t+7QUORMlRCA1lLhekPrR3ag7hmX++DrSOBQunTMLFM=";
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
