{stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation {
  name = "mpg123-1.15.4";

  src = fetchurl {
    url = mirror://sourceforge/mpg123/mpg123-1.15.4.tar.bz2;
    sha256 = "05aizspky9mp1bq2lfrkjzrsnjykl7gkbrhn93xcarj5b2izv1b8";
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
