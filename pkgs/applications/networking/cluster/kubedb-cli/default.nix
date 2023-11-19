{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubedb-cli";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "kubedb";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-nDLdATiUcg5o86Pda1/Do9dPMtdNCUo/xj6ERRzih8w=";
  };

  vendorHash = null;

  # Don't compile the documentation stuff
  subPackages = [ "cmd/kubectl-dba" ];

  meta = with lib; {
    description = "kubectl plugin for KubeDB by AppsCode.";
    homepage    = "https://github.com/kubedb/cli";
    license     = licenses.unfree;
    maintainers = [ maintainers.starcraft66 ];
  };
}
