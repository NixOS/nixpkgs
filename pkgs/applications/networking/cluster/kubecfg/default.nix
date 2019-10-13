{ lib, buildGoPackage, fetchFromGitHub, ... }:

let version = "0.12.5"; in

buildGoPackage {
  pname = "kubecfg";
  inherit version;

  src = fetchFromGitHub {
    owner = "bitnami";
    repo = "kubecfg";
    rev = "v${version}";
    sha256 = "0pn37qkwn3kdsd0z3qxk95lqjn2zak7gkk0pwlqp26jmrx0vv18l";
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
