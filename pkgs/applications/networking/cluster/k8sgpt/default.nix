{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k8sgpt";
  version = "0.3.30";

  src = fetchFromGitHub {
    owner = "k8sgpt-ai";
    repo = "k8sgpt";
    rev = "v${version}";
    hash = "sha256-iseyvGo9fitt8bAlbU3wF7bBLz66fijb8h35aank+0k=";
  };

  vendorHash = "sha256-YpCn7hZkMj3/dIC/ZMslTjXcumCH3LH/A7pjfJ0pUd4=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X main.version=v${version}"
    "-X main.commit=${src.rev}"
    "-X main.date=1970-01-01-00:00:01"
  ];

  meta = {
    description = "Giving Kubernetes Superpowers to everyone";
    mainProgram = "k8sgpt";
    homepage = "https://k8sgpt.ai";
    changelog = "https://github.com/k8sgpt-ai/k8sgpt/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ developer-guy kranurag7 ];
  };
}
