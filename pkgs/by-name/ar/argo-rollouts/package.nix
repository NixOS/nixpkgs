{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "argo-rollouts";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-rollouts";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-qpTilslCu9rmBVMo73lHnKD8NPxLHSzeBwkWhEB4If4=";
  };

  vendorHash = "sha256-bF4jIEEG5DFhtDdy8LwK6SfE5OdyUsDjOIbAddvb5V8=";

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
