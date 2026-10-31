{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubedb-cli";
  version = "0.68.0";

  src = fetchFromGitHub {
    owner = "kubedb";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-xyvdHWAtbM/BiWjaZZJFF6fZtUIJeRRK5GrpMTv+Oaw=";
  };

  vendorHash = null;

  # Don't compile the documentation stuff
  subPackages = [ "cmd/kubectl-dba" ];

  meta = {
    description = "kubectl plugin for KubeDB by AppsCode";
    homepage = "https://github.com/kubedb/cli";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.starcraft66 ];
  };
}
