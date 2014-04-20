{stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation {
  name = "mpg123-1.19.0";

  src = fetchurl {
    url = mirror://sourceforge/mpg123/mpg123-1.19.0.tar.bz2;
    sha256 = "06xhd68mj9yp0r6l771aq0d7xgnl402a3wm2mvhxmd3w3ph29446";
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
