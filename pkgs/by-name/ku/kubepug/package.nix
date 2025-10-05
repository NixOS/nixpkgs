{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubepug";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "kubepug";
    repo = "kubepug";
    rev = "v${version}";
    hash = "sha256-VNxaYQy81U0JWd6KS0jCvMexpyWL4v1cKpjxLRkxBLE=";
  };

  vendorHash = "sha256-HVsaQBd7fSZp2fOpOOmlDhYrHcHqWKiYWPFLQX0azEw=";

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=${version}"
  ];

  meta = with lib; {
    description = "Checks a Kubernetes cluster for objects using deprecated API versions";
    homepage = "https://github.com/kubepug/kubepug";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch ];
  };
}
