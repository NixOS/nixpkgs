{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "container2wasm";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "ktock";
    repo = "container2wasm";
    tag = "v${version}";
    hash = "sha256-detM0A8pm65VmEuEh7Xc+LcXfz4aq9p46NvJtdzfzAA=";
  };

  vendorHash = "sha256-G75YojD+GR1C++crDkWS3A4nrUI9HwZfxmKpdNZ7qYY=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ktock/container2wasm/version.Version=${version}"
  ];

  subPackages = [
    "cmd/c2w"
  ];

  meta = with lib; {
    description = "Container to WASM converter";
    homepage = "https://github.com/ktock/container2wasm";
    changelog = "https://github.com/ktock/container2wasm/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "c2w";
  };
}
