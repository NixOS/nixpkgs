{ lib, buildGoPackage, fetchFromGitHub, ... }:

let version = "0.5.0"; in

buildGoPackage {
  name = "kubecfg-${version}";

  src = fetchFromGitHub {
    owner = "ksonnet";
    repo = "kubecfg";
    rev = "v${version}";
    sha256 = "1s8w133p8qkj3dr73jimajm9ddp678lw9k9symj8rjw5p35igr93";
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
