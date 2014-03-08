{stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation {
  name = "mpg123-1.18.1";

  src = fetchurl {
    url = mirror://sourceforge/mpg123/mpg123-1.18.1.tar.bz2;
    sha256 = "0bb5hv0qw3ln09xisi7d19gb4p2y69sx3905rdc293q3gr7khvdw";
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
