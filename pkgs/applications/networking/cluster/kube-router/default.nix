{ lib, buildGoModule, fetchFromGitHub, testers, kube-router }:

buildGoModule rec {
  pname = "kube-router";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "cloudnativelabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5aOAQ5kRnNsCn5EH9RKoeEfcFB3g59eqYIdSNjQxdjM=";
  };

  vendorHash = "sha256-5aGcDO+dV9XinH0vw6uNB0mnWuFQcyLhRB7zYr+sRfg=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cloudnativelabs/kube-router/v2/pkg/version.Version=${version}"
    "-X github.com/cloudnativelabs/kube-router/v2/pkg/version.BuildDate=Nix"
  ];

  passthru.tests.version = testers.testVersion {
    package = kube-router;
  };

  meta = with lib; {
    homepage = "https://www.kube-router.io/";
    description = "All-in-one router, firewall and service proxy for Kubernetes";
    mainProgram = "kube-router";
    license = licenses.asl20;
    maintainers = with maintainers; [ colemickens johanot ];
    platforms = platforms.linux;
  };
}
