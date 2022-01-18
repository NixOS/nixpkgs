{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "sic";
  version = "1.2";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/sic-${version}.tar.gz";
    sha256 = "ac07f905995e13ba2c43912d7a035fbbe78a628d7ba1c256f4ca1372fb565185";
  };

  makeFlags = [ "CC:=$(CC)" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Simple IRC client";
    homepage = "https://tools.suckless.org/sic/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
