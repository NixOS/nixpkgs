{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "wego-${version}";
  version = "20170403-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "415efdfab5d5ee68300bf261a0c6f630c6c2584c";
  
  goPackagePath = "github.com/schachmat/wego";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/schachmat/wego";
    sha256 = "0w8sypwg0s2mvhk9cdibqr8bz5ipiiacs60a39sdswrpc4z486hg";
  };

  goDeps = ./deps.nix;

  meta = {
    license = stdenv.lib.licenses.isc;
  };
}
