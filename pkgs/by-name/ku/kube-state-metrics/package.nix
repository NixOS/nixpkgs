{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kube-state-metrics";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kube-state-metrics";
    rev = "v${version}";
    hash = "sha256-w55FOWw9p7yV/bt4leZucOLqjVyHYFF+gVLWLGQKF9M=";
  };

  vendorHash = "sha256-pcoqeYyOehFNkwD4fWqrk9725BJkv+8sKy1NLv+HJPE=";

  excludedPackages = [
    "./tests/e2e"
    "./tools"
  ];

  meta = {
    homepage = "https://github.com/kubernetes/kube-state-metrics";
    description = "Add-on agent to generate and expose k8s cluster-level metrics";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.eskytthe ];
    platforms = lib.platforms.unix;
  };
}
