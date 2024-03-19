{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k8sgpt";
  version = "0.3.28";

  src = fetchFromGitHub {
    owner = "k8sgpt-ai";
    repo = "k8sgpt";
    rev = "v${version}";
    hash = "sha256-VDVCkGTLoAZZyTX+zn43KisnUV9XQ9xo9ZIQf3AwDcY=";
  };

  vendorHash = "sha256-NOXySV9sQl4Q1eDbcGMk0msMSosjyxYyJfhu7hd/4gw=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X main.version=v${version}"
    "-X main.commit=${src.rev}"
    "-X main.date=1970-01-01-00:00:01"
  ];

  meta = with lib; {
    description = "Giving Kubernetes Superpowers to everyone";
    mainProgram = "k8sgpt";
    homepage = "https://k8sgpt.ai";
    changelog = "https://github.com/k8sgpt-ai/k8sgpt/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ developer-guy kranurag7 ];
  };
}
