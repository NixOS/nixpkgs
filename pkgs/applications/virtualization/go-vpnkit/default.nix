{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vpnkit-unstable-${version}";
  version = "2017-06-28";
  rev = "db7b7b0f8147f29360d69dc81af9e2877647f0de";

  goPackagePath = "github.com/moby/vpnkit";

  src = fetchFromGitHub {
    owner = "moby";
    repo = "vpnkit";
    inherit rev;
    sha256 = "192mfrhyyhfszjbd052gpmnf2gr86sxc2wfid45cc1dcdnljcshx";
  };

  postInstall = ''
    ln -s $bin/bin/vpnkit-forwarder $bin/bin/vpnkit-expose-port
  '';

  meta = {
    description = "Client commands for VPNKit";
    homepage = "https://github.com/moby/vpnkit";
    maintainers = [ lib.maintainers.puffnfresh ];
    platforms = lib.platforms.linux;
  };
}
