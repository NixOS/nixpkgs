{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kube-state-metrics";
  version = "2.19.1";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kube-state-metrics";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PZC3ZiVnChy7IdibZKB3IRv8+1AfmvAWY7RquwTcS1Y=";
  };

  vendorHash = "sha256-vmmXEDzkv+ZQaKJ6++HpPHj2M9gaquonNjXG2DOlxwI=";

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
})
