{ lib, buildGoModule, fetchFromGitHub, testers, kube-router }:

buildGoModule rec {
  pname = "kube-router";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "cloudnativelabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-N1AC4r5NLW7hxBHGFRKcDZ1sLLKlcqqNmXeh8Zt3l1g=";
  };

  vendorHash = "sha256-Yai6nszdaw2TwOi9N3BkY/4zz2aJGdCqWskHmnBKTDk=";

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
