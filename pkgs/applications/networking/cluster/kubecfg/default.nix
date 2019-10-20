{ lib, buildGoPackage, fetchFromGitHub, ... }:

let version = "0.13.1"; in

buildGoPackage {
  pname = "kubecfg";
  inherit version;

  src = fetchFromGitHub {
    owner = "bitnami";
    repo = "kubecfg";
    rev = "v${version}";
    sha256 = "0x2mg13p8r1sgqr1bbzh57kfymb8z392y43djgks2agc7rjnd45f";
  };

  goPackagePath = "github.com/bitnami/kubecfg";

  meta = {
    description = "A tool for managing Kubernetes resources as code";
    homepage = https://github.com/bitnami/kubecfg;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benley ];
    platforms = lib.platforms.unix;
  };
}
