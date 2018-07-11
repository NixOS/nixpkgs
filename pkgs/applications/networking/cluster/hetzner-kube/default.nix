{ lib, buildGoPackage, fetchFromGitHub, ... }:

let version = "0.3.1"; in

buildGoPackage {
  name = "hetzner-kube-${version}";

  src = fetchFromGitHub {
    owner = "xetys";
    repo = "hetzner-kube";
    rev = "${version}";
    sha256 = "1xldh1ca8ym8cg3w5cxizmhqxwi5kmiin28f320mxdr28fzljc2w";
  };

  goPackagePath = "github.com/xetys/hetzner-kube";

  meta = {
    description = "A CLI tool for provisioning Kubernetes clusters on Hetzner Cloud";
    homepage = https://github.com/xetys/hetzner-kube;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eliasp ];
    platforms = lib.platforms.unix;
  };
}
