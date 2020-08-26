{ stdenv
, fetchurl, alsaLib
}:

stdenv.mkDerivation rec {
  name = "mpg123-1.26.3";

  src = fetchurl {
    url = "mirror://sourceforge/mpg123/${name}.tar.bz2";
    sha256 = "0vkcfdx0mqq6lmpczsmpa2jsb0s6dryx3i7gvr32i3w9b9w9ij9h";
  };

  buildInputs = stdenv.lib.optional (!stdenv.isDarwin) alsaLib;

  configureFlags = stdenv.lib.optional
    (stdenv.hostPlatform ? mpg123)
    "--with-cpu=${stdenv.hostPlatform.mpg123.cpu}";

  meta = {
    description = "Fast console MPEG Audio Player and decoder library";
    homepage = "http://mpg123.org";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.ftrvxmtrx ];
    platforms = stdenv.lib.platforms.unix;
  };
}
