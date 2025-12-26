{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "k8sgpt";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "k8sgpt-ai";
    repo = "k8sgpt";
    rev = "v${version}";
    hash = "sha256-TaJBGU+nLMVOL1uiHPan8p2DfuAWTr57Lt2BtfNq6dA=";
  };

  vendorHash = "sha256-960gfOCpqY2gCbHR+fYFeV9UjztWMRVQKHIg/n3ELxk=";

  # https://nixos.org/manual/nixpkgs/stable/#var-go-CGO_ENABLED
  env.CGO_ENABLED = 0;

  # https://nixos.org/manual/nixpkgs/stable/#ssec-skip-go-tests
  ldflags = [
    "-s"
    "-w"
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
    maintainers = with lib.maintainers; [
      developer-guy
      kranurag7
      mrgiles
    ];
  };
}
