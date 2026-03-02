{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "argo-rollouts";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-rollouts";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-LT5RV5dBqcEloKUm9RCDxPncxScYVlYVWWYUld1iO0M=";
  };

  vendorHash = "sha256-+qdj72kjpctQabalcmjqk5DhptvBOzGErn9cpRkGqlk=";

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
