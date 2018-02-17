{ lib, buildGoPackage, fetchFromGitHub, ... }:

let version = "0.6.0"; in

buildGoPackage {
  name = "kubecfg-${version}";

  src = fetchFromGitHub {
    owner = "ksonnet";
    repo = "kubecfg";
    rev = "v${version}";
    sha256 = "12kv1p707kdxjx5l8rcikd1gjwp5xjxdmmyvlpnvyagrphgrwpsf";
  };

  goPackagePath = "github.com/ksonnet/kubecfg";

  meta = {
    description = "A tool for managing Kubernetes resources as code";
    homepage = https://github.com/ksonnet/kubecfg;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benley ];
    platforms = lib.platforms.unix;
  };
}
