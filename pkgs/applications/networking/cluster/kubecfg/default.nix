{ lib, buildGoPackage, fetchFromGitHub, ... }:

let version = "0.12.0"; in

buildGoPackage {
  pname = "kubecfg";
  inherit version;

  src = fetchFromGitHub {
    owner = "bitnami";
    repo = "kubecfg";
    rev = "v${version}";
    sha256 = "118p1fy6cihswwz03vp62cz8395hgfqd82nmfkw88fx7av23rfhb";
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
