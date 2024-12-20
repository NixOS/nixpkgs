{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "container2wasm";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "ktock";
    repo = "container2wasm";
    rev = "refs/tags/v${version}";
    hash = "sha256-Awk7tC5eyapbra/GlwPPfYx+Jh5UHlK9zo9ZRCVz9S0=";
  };

  vendorHash = "sha256-X6JG/D+f9MmZVGqic13OkyPriLloEazU6dqDjue6YmY=";

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
