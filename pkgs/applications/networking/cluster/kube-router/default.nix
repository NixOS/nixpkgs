{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  kube-router,
}:

buildGoModule rec {
  pname = "kube-router";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "cloudnativelabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BjL91c+yfpscb0q62eWfiqg1aLkXztXowTj4k8jdTQs=";
  };

  vendorHash = "sha256-BrpjG9DhDQSsbeJ+1MRAwXyKVULK3KHjvLydduTb024=";

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
    maintainers = with maintainers; [
      colemickens
      johanot
    ];
    platforms = platforms.linux;
  };
}
