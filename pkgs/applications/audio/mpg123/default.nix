{stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation {
  name = "mpg123-1.16.0";

  src = fetchurl {
    url = mirror://sourceforge/mpg123/mpg123-1.16.0.tar.bz2;
    sha256 = "1lznnfdvg69a9qbbhvhfc9i86hxdmdqx67lvbkqbh8mmhpip43zh";
  };

  buildInputs = stdenv.lib.optional (!stdenv.isDarwin) alsaLib;

  crossAttrs = {
    configureFlags = if stdenv.cross ? mpg123 then
      "--with-cpu=${stdenv.cross.mpg123.cpu}" else "";
  };

  meta = {
    description = "Command-line MP3 player";
    homepage = http://mpg123.sourceforge.net/;
    license = "LGPL";
  };
}
