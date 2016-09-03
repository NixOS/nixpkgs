{ stdenv, fetchurl, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "parity-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/ethcore/parity/archive/v${version}.tar.gz";
    sha256 = "07n2s29iyjp112shq1mphy1mglb829q3jblk06i6abba234c7dm2";
  };

  depsSha256 = "0zaldalxpxxmwni93n05rfj6xfpyvbfqhyj01szc74nf3v5q04y6";

  meta = {
    description = "Fast, light, robust Ethereum implementation";
    homepage = http://ethcore.io/parity;
    license = stdenv.lib.licenses.gpl3;
    inherit version;
  };
}
