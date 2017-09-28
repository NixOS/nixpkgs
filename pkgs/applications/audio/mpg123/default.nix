{stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation rec {
  name = "mpg123-1.25.7";

  src = fetchurl {
    url = "mirror://sourceforge/mpg123/${name}.tar.bz2";
    sha256 = "1ws40fglyyk51jvmz8gfapjkw1g51pkch1rffdsbh4b1yay5xc9i";
  };

  buildInputs = stdenv.lib.optional (!stdenv.isDarwin) alsaLib;

  crossAttrs = {
    configureFlags = if stdenv.cross ? mpg123 then
      "--with-cpu=${stdenv.cross.mpg123.cpu}" else "";
  };

  meta = {
    description = "Fast console MPEG Audio Player and decoder library";
    homepage = http://mpg123.org;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.ftrvxmtrx ];
    platforms = stdenv.lib.platforms.unix;
  };
}
