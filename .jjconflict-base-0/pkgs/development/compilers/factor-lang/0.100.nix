{ callPackage, fetchurl }:

callPackage ./unwrapped.nix (rec {
  version = "0.100";
  src = fetchurl {
    url = "https://downloads.factorcode.org/releases/${version}/factor-src-${version}.zip";
    hash = "sha256-ei1x6mgEoDVe1mKfoWSGC9RgZCONovAPYfIdAlOGi+0=";
  };
})
