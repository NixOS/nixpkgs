{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kube-state-metrics";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kube-state-metrics";
    rev = "v${version}";
    hash = "sha256-EBSlufgzT4zgxTO5B0/RHHJJ2GgtU3U9ypd1QjC3knE=";
  };

  vendorHash = "sha256-A/oiFEWM3TOtk4V3xpehJ+5oKSyzYKZHVlp3wjykFRA=";

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
