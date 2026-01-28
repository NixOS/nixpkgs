{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kube-state-metrics";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kube-state-metrics";
    rev = "v${version}";
    hash = "sha256-oLkIjc6VC3hTrFg9LmgSUtwt4ek0dT7h2u2DfNRx5Gg=";
  };

  vendorHash = "sha256-ccP34lywpQnIx3R5IyGURuvb4ijNfCu2VVAeVjBrN0w=";

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
