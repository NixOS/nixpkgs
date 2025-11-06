{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "container2wasm";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "ktock";
    repo = "container2wasm";
    tag = "v${version}";
    hash = "sha256-cE/cKMMslu4GGVV3aRcdsu7cTdsVABZLs8GX6ihgW38=";
  };

  vendorHash = "sha256-vKvQyrdmtPAjcaXU374eYPll5+Samo+zbaiMjOtGp7I=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ktock/container2wasm/version.Version=${version}"
  ];

  subPackages = [
    "cmd/c2w"
  ];

  meta = {
    description = "Container to WASM converter";
    homepage = "https://github.com/ktock/container2wasm";
    changelog = "https://github.com/ktock/container2wasm/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "c2w";
  };
}
