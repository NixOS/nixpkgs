{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "wego-${version}";
  version = "20160407-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "81d72ffd761f032fbd73dba4f94bd94c8c2d53d5";
  
  goPackagePath = "github.com/schachmat/wego";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/schachmat/wego";
    sha256 = "14p3hvv82bsxqnbnzz8hjv75i39kzg154a132n6cdxx3vgw76gck";
  };

  goDeps = ./deps.json;
}
