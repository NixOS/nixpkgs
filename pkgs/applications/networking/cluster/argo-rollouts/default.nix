{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "argo-rollouts";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-rollouts";
    rev = "v${version}";
    sha256 = "0qb1wbv3razwhqsv972ywfazaq73y83iw6f6qdjcbwwfwsybig21";
  };

  vendorSha256 = "00ic1nn3wgg495x2170ik1d1cha20b4w89j9jclq8p0b3nndv0c0";

  # Disable tests since some test fail because of missing test data
  doCheck = false;

  subPackages = [ "cmd/rollouts-controller" "cmd/kubectl-argo-rollouts" ];

  meta = with lib; {
    description = "Kubernetes Progressive Delivery Controller";
    homepage = "https://github.com/argoproj/argo-rollouts/";
    license = licenses.asl20;
    maintainers = with maintainers; [ psibi ];
  };
}
