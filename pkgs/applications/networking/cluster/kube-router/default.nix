{ lib, buildGoModule, fetchFromGitHub, testers, kube-router }:

buildGoModule rec {
  pname = "kube-router";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "cloudnativelabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7laXw0tC25zPTeLJlB/rX6WVcRFCd6DCB+3EUPnE4cM=";
  };

  vendorHash = "sha256-qJA6gnb+VIkJD24iq6yyn8r4zYY19ZywcyalwfaTtbo=";

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
    license = licenses.asl20;
    maintainers = with maintainers; [ colemickens johanot ];
    platforms = platforms.linux;
  };
}
