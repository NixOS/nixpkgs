{ lib, buildGoPackage, fetchFromGitHub, ... }:

buildGoPackage rec {
  version = "0.11.0";
  name = "ksonnet-${version}";

  src = fetchFromGitHub {
    owner = "ksonnet";
    repo = "ksonnet";
    rev = "v${version}";
    sha256 = "0z7gkgcsiclm72bznmzv5jcgx5rblndcsiqc0r2mwhxhmv19bs04";
  };

  goPackagePath = "github.com/ksonnet/ksonnet";

  meta = {
    description = "A CLI-supported framework that streamlines writing and deployment of Kubernetes configurations to multiple clusters";
    homepage = https://github.com/ksonnet/ksonnet;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ flokli ];
    platforms = lib.platforms.unix;
  };
}
