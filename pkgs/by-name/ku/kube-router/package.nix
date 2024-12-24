{ lib, buildGoModule, fetchFromGitHub, testers, kube-router }:

buildGoModule rec {
  pname = "kube-router";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "cloudnativelabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eyO8eMlxWobUQBuswh4kM07kJV3fsRz4gTeP/tIR3aM=";
  };

  vendorHash = "sha256-KmAMGKm+cFGRMD1Nyn9/CHv9vUvflAiLJcro08GIGtw=";

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

  meta = with lib; {
    homepage = "https://www.kube-router.io/";
    description = "All-in-one router, firewall and service proxy for Kubernetes";
    mainProgram = "kube-router";
    license = licenses.asl20;
    maintainers = with maintainers; [ johanot ];
    platforms = platforms.linux;
  };
}
