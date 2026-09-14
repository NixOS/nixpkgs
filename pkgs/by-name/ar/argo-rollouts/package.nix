{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "argo-rollouts";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-rollouts";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-DEpMNK/NDXykfYDWUCvLm+zoNaQ4YRGExznJoW3l5F0=";
  };

  vendorHash = "sha256-UccmVVb640CnhmByMc/pB+RyYoDdgBX88U3zhcQ/jpg=";

  # Disable tests since some test fail because of missing test data
  doCheck = false;

  subPackages = [
    "cmd/rollouts-controller"
    "cmd/kubectl-argo-rollouts"
  ];

  meta = {
    description = "Kubernetes Progressive Delivery Controller";
    homepage = "https://github.com/argoproj/argo-rollouts/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ psibi ];
  };
})
