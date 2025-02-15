{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "controller-tools";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "controller-tools";
    tag = "v${version}";
    sha256 = "sha256-AUYduzIEWCJDskoChXmQViR5ON4YZr4MKvFys03hBkY=";
  };

  vendorHash = "sha256-Y7xYmD3fxAIo/NyLzBuSdbHIrduJ33SpK2I6LfOzNac=";

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
