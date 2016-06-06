{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "drive-${version}";
  version = "20151025-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "6dc2f1e83032ea3911fa6147b846ee93f18dc544";

  goPackagePath = "github.com/odeke-em/drive";
  subPackages = [ "cmd/drive" ];

  src = fetchgit {
    inherit rev;
    url = "https://github.com/odeke-em/drive";
    sha256 = "07s4nhfcr6vznf1amvl3a4wq2hn9zq871rcppfi4i6zs7iw2ay1v";
  };

  goDeps = ./deps.json;
}
