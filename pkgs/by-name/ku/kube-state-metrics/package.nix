{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kube-state-metrics";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kube-state-metrics";
    rev = "v${version}";
    hash = "sha256-s46K5V7lwqeQ4qjaCPAoMoKLikezT+Ik5bJAkkJ5Q40=";
  };

  vendorHash = "sha256-3g3iPgc60u+zh1YZoWv4aPOJM2TmVzrlBmRoaxrEORo=";

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
