{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  kube-router,
}:

buildGoModule rec {
  pname = "kube-router";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "cloudnativelabs";
    repo = "kube-router";
    rev = "v${version}";
    hash = "sha256-0UuUDIIDedHDo2gVNg/4Ilcyw7BzUCJFdhn/GOi5QNs=";
  };

  vendorHash = "sha256-fXZ6jRlFdjYPV5wqSdWAMlHj1dkkEpbCtcKMuuoje1U=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cloudnativelabs/kube-router/v2/pkg/version.Version=${version}"
    "-X github.com/cloudnativelabs/kube-router/v2/pkg/version.BuildDate=Nix"
  ];

  passthru.tests.version = testers.testVersion {
    package = kube-router;
  };

  meta = {
    homepage = "https://www.kube-router.io/";
    description = "All-in-one router, firewall and service proxy for Kubernetes";
    mainProgram = "kube-router";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ johanot ];
    platforms = lib.platforms.linux;
  };
}
