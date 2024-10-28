{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "k8sgpt";
  version = "0.3.41";

  src = fetchFromGitHub {
    owner = "k8sgpt-ai";
    repo = "k8sgpt";
    rev = "v${version}";
    hash = "sha256-p53gVpFhxr60OEZSASRU5KX7TkWzYCDAvG9aQj2NFHI=";
  };

  vendorHash = "sha256-9H6E1JUbxfcx3Baithu9Jr6MpxfuKE+XWz7HrTCdxA8=";

  # https://nixos.org/manual/nixpkgs/stable/#var-go-CGO_ENABLED
  CGO_ENABLED = 0;

  # https://nixos.org/manual/nixpkgs/stable/#ssec-skip-go-tests
  checkFlags = [
    "-skip=TestActivate/trivy"
  ];

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
