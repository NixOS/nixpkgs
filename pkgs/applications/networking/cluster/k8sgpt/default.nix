{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k8sgpt";
  version = "0.3.17";

  src = fetchFromGitHub {
    owner = "k8sgpt-ai";
    repo = "k8sgpt";
    rev = "v${version}";
    hash = "sha256-vSytBicpYWs7MqVts+3d6qVZ19nrM1oi00YRPmCQb/I=";
  };

  vendorHash = "sha256-UFXESGdipfM/TI/9ZSVwoUPsd3LVeEmTFB6sVqkkzQo=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X main.version=v${version}"
    "-X main.commit=${src.rev}"
    "-X main.date=1970-01-01-00:00:01"
  ];

  meta = with lib; {
    description = "Giving Kubernetes Superpowers to everyone";
    homepage = "https://k8sgpt.ai";
    changelog = "https://github.com/k8sgpt-ai/k8sgpt/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ developer-guy kranurag7 ];
  };
}
