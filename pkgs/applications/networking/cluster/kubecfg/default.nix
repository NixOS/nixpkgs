{ lib, buildGoPackage, fetchFromGitHub, ... }:

let version = "0.9.1"; in

buildGoPackage {
  name = "kubecfg-${version}";

  src = fetchFromGitHub {
    owner = "ksonnet";
    repo = "kubecfg";
    rev = "v${version}";
    sha256 = "010k33arxa4spaq923iazsisxgsaj8c7w4z250y9yrch8xxd74bi";
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
