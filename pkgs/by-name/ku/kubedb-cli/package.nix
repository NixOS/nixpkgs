{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubedb-cli";
  version = "0.59.0";

  src = fetchFromGitHub {
    owner = "kubedb";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-gM61Om1qNbzeHWAzLbgUlHsZPzBNzyFN8r9PoS3Pf1c=";
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
