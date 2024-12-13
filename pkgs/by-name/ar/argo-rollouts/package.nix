{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "argo-rollouts";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-rollouts";
    rev = "v${version}";
    sha256 = "sha256-KljhBI7vNqQVV0UeFRXfdan1gEiwS1CwokgWnJ1RR5Q=";
  };

  vendorHash = "sha256-38BLPNc6en70+UxlldmrwtRTMRLh/fCPL6FtuA2ODGM=";

  # Disable tests since some test fail because of missing test data
  doCheck = false;

  subPackages = [
    "cmd/rollouts-controller"
    "cmd/kubectl-argo-rollouts"
  ];

  meta = with lib; {
    description = "Kubernetes Progressive Delivery Controller";
    homepage = "https://github.com/argoproj/argo-rollouts/";
    license = licenses.asl20;
    maintainers = with maintainers; [ psibi ];
  };
}
