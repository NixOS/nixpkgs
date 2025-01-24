{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "controller-tools";
  version = "0.16.5";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6It4C8TWA8V0YwUHoSoJK8IbjZ8yfBzR5iX9lzenIY0=";
  };

  vendorHash = "sha256-wS1+cUXZzfDz5BRHcqV8T050z54VrJB4FcWqRzwsYrc=";

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
