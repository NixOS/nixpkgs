{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "controller-tools";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "controller-tools";
    tag = "v${version}";
    sha256 = "sha256-YBg6sf7G9xsSkLarA9wRlCg1Knu/c8Y9kpscRKNpVmk=";
  };

  vendorHash = "sha256-YRY/gILgJyLoMUG0v5HiAWN7lEzjCc7TJSZgRiN2tZs=";

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/controller-tools/pkg/version.version=v${version}"
  ];

  doCheck = false;

  subPackages = [
    "cmd/controller-gen"
    "cmd/type-scaffold"
    "cmd/helpgen"
  ];

  meta = with lib; {
    description = "Tools to use with the Kubernetes controller-runtime libraries";
    homepage = "https://github.com/kubernetes-sigs/controller-tools";
    changelog = "https://github.com/kubernetes-sigs/controller-tools/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ michojel ];
  };
}
