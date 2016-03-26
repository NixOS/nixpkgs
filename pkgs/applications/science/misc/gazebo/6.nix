{ stdenv, fetchurl, callPackage, sdformat3, ... } @ args:

callPackage ./default.nix (args // rec {
  version = "6.0.0";
  src-sha256 = "10kmh4kkry6mn0vkmihb8arklkz6af97iv8c5nvkyd3m41r1fpds";
  sdformat = sdformat3;
})

