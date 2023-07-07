{ lib, buildGoModule, fetchFromGitHub, testers, kube-router }:

buildGoModule rec {
  pname = "kube-router";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "cloudnativelabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/ruSSq+iHmJDFHH+mLoqtdljAGlc15lXjTqq+luJIU8=";
  };

  vendorHash = "sha256-U2TvH4TPBI6verEcyv0Z+ZFAKbADgzncJhW1IAJw4Ms=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cloudnativelabs/kube-router/pkg/version.Version=${version}"
    "-X github.com/cloudnativelabs/kube-router/pkg/version.BuildDate=Nix"
  ];

  passthru.tests.version = testers.testVersion {
    package = kube-router;
  };

  meta = with lib; {
    homepage = "https://www.kube-router.io/";
    description = "All-in-one router, firewall and service proxy for Kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ colemickens johanot ];
    platforms = platforms.linux;
  };
}
