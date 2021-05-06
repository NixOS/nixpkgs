{ lib, buildGoPackage, fetchFromGitHub, ... }:

let version = "0.19.0"; in

buildGoPackage {
  pname = "kubecfg";
  inherit version;

  src = fetchFromGitHub {
    owner = "bitnami";
    repo = "kubecfg";
    rev = "v${version}";
    sha256 = "sha256-G3yLpo/6hv6t3i6b/KMgoZqltyGDddg/SsNPF8hNeUg=";
  };

  goPackagePath = "github.com/bitnami/kubecfg";

  meta = {
    description = "A tool for managing Kubernetes resources as code";
    homepage = "https://github.com/bitnami/kubecfg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benley ];
    platforms = lib.platforms.unix;
  };
}
