{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kube-state-metrics";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kube-state-metrics";
    rev = "v${version}";
    hash = "sha256-qLn+2znmfIdBkoVkCJ0tFAPVRYc+qAJWKbDP2FqMocg=";
  };

  vendorHash = "sha256-KyEGmtSQO0EERLb0I7NBmxv1Jz+bYMrCZVwjJ1Jt+Ik=";

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
