{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubepug";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "kubepug";
    repo = "kubepug";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VNxaYQy81U0JWd6KS0jCvMexpyWL4v1cKpjxLRkxBLE=";
  };

  vendorHash = "sha256-HVsaQBd7fSZp2fOpOOmlDhYrHcHqWKiYWPFLQX0azEw=";

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=${finalAttrs.version}"
  ];

  meta = {
    description = "Checks a Kubernetes cluster for objects using deprecated API versions";
    homepage = "https://github.com/kubepug/kubepug";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mausch ];
  };
})
