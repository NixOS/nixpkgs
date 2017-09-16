{ stdenv, lib, fetchurl }:

let
  rev = "db7b7b0f8147f29360d69dc81af9e2877647f0de";
in
stdenv.mkDerivation rec {
  name = "vpnkit-${version}";
  version = lib.strings.substring 0 7 rev;

  src = fetchurl {
    url = https://931-58395340-gh.circle-artifacts.com/0/Users/distiller/vpnkit/vpnkit.tgz;
    sha256 = "0rwrxi3c9yri0n3m8iznpqy5wql7b9j6khzfsdxvflr44s7jr0x3";
  };

  sourceRoot = ".";

  installPhase = ''
    APP=$out/Applications/VPNKit/
    mkdir -p $APP
    mkdir -p $out/bin
    cp -r Contents $APP
    ln -s $APP/Contents/MacOS/vpnkit $out/bin/vpnkit
  '';

  meta = {
    description = "VPN-friendly networking devices for HyperKit";
    homepage = "https://github.com/moby/vpnkit";
    maintainers = [ lib.maintainers.puffnfresh ];
    platforms = lib.platforms.darwin;
  };
}
