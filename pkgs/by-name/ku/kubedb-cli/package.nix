{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubedb-cli";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "kubedb";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-9LHDf2la4cAnppv1yS1wUob87mjsfR7SGfuxiFtICqA=";
  };

  vendorHash = null;

  # Don't compile the documentation stuff
  subPackages = [ "cmd/kubectl-dba" ];

  meta = with lib; {
    description = "kubectl plugin for KubeDB by AppsCode";
    homepage = "https://github.com/kubedb/cli";
    license = licenses.unfree;
    maintainers = [ maintainers.starcraft66 ];
  };
}
