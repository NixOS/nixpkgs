{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kube-state-metrics";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kube-state-metrics";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tgPbb7N/ZrIJqJF50kpJ5VOADSHnJ7dprxvL+J81Tjk=";
  };

  vendorHash = "sha256-RuX/E/kfVLP+8hk0ixhAZQQuj2+ZXNpquyNNduB8CAA=";

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
