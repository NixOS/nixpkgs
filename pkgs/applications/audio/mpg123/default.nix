{ stdenv
, fetchurl, alsaLib
, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "mpg123-1.25.4";

  src = fetchurl {
    url = "mirror://sourceforge/mpg123/${name}.tar.bz2";
    sha256 = "1rxknrnl3ji5hi5rbckpzhbl1k5r8i53kcys4xdgg0xbi8765dfd";
  };

  buildInputs = stdenv.lib.optional (!stdenv.isDarwin) alsaLib;

  configureFlags =
    stdenv.lib.optional (hostPlatform ? mpg123) "--with-cpu=${hostPlatform.mpg123.cpu}";

  meta = {
    description = "Fast console MPEG Audio Player and decoder library";
    homepage = http://mpg123.org;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.ftrvxmtrx ];
    platforms = stdenv.lib.platforms.unix;
  };
}
