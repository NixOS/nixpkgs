{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "controller-tools";
<<<<<<< HEAD
  version = "0.20.0";
=======
  version = "0.19.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "controller-tools";
    tag = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Cjn8o5AhmIE9UFT38cyIUnT/3pG1dJGWivYvVIbUAAk=";
  };

  vendorHash = "sha256-cFnUfcoLyFHg0JR6ix0AnpSHUGuNNVbKldKelvvMu/4=";
=======
    sha256 = "sha256-NPyX89Hr1MAUdMafEEvcf/geQD1PxkDFSRPCFZBh29g=";
  };

  vendorHash = "sha256-97FtwBaN8rMTsz9XbTEB1PSC454N2SLSWyOzXSWld9Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

  meta = {
    description = "Tools to use with the Kubernetes controller-runtime libraries";
    homepage = "https://github.com/kubernetes-sigs/controller-tools";
    changelog = "https://github.com/kubernetes-sigs/controller-tools/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ michojel ];
  };
}
