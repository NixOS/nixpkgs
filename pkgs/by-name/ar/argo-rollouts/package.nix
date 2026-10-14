{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "argo-rollouts";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-rollouts";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-AC1a6tMxZBvwb/uofiJ99q72wI1VmbYr3HSJBsfNXK4=";
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
