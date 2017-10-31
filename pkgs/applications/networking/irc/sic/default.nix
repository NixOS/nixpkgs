{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "sic-${version}";
  version = "1.2";

  makeFlags = "PREFIX=$(out)";
  src = fetchurl {
    url = "http://dl.suckless.org/tools/sic-${version}.tar.gz";
    sha256 = "ac07f905995e13ba2c43912d7a035fbbe78a628d7ba1c256f4ca1372fb565185";
  };

  meta = {
    description = "Simple IRC client";
    homepage = http://tools.suckless.org/sic/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
  };
}
