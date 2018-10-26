{ lib, buildGoPackage, fetchFromGitHub, ... }:

buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "hetzner-kube";
  version = "0.3.2-rc1";

  src = fetchFromGitHub {
    owner = "xetys";
    repo = "hetzner-kube";
    rev = version;
    sha256 = "16pzcpcr98rcrv5k57fa7h9a82wiv4p2ckhkmisynkr7f1xk60mw";
  };

  goPackagePath = "github.com/xetys/hetzner-kube";
  subPackages = ["."];
  goDeps = ./deps.nix;

  meta = {
    description = "A CLI tool for provisioning Kubernetes clusters on Hetzner Cloud";
    homepage = https://github.com/xetys/hetzner-kube;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eliasp ];
    platforms = lib.platforms.unix;
  };
}
