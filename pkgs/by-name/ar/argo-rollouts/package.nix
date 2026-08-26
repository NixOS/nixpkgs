{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "argo-rollouts";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-rollouts";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-DQD4tQ3NrmTujHlf23PHW88z0cY3gM5GCkv3s4/D6wg=";
  };

  vendorHash = "sha256-HFpleG5e+F0cclAY37mJnf+g188WlOl6sQaINhuuToE=";

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
