{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubedb-cli";
  version = "0.65.0";

  src = fetchFromGitHub {
    owner = "kubedb";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-DHICxjymoqmvEnff4ABVJSuCh8Ojx/RTxgUPlO94HLo=";
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
