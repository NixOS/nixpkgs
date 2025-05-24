{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "container2wasm";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "ktock";
    repo = "container2wasm";
    tag = "v${version}";
    hash = "sha256-uMZD2FytXNK9XErSsiuUVDTeQ+Pjx0RrDnGa7Sj8MsY=";
  };

  vendorHash = "sha256-RqLhGDmtSthYh9GexFuTjLHp9kL7QvyL+O27+5suhlA=";

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
