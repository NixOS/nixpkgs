{ stdenv
, fetchurl, alsaLib
}:

stdenv.mkDerivation rec {
  name = "mpg123-1.25.11";

  src = fetchurl {
    url = "mirror://sourceforge/mpg123/${name}.tar.bz2";
    sha256 = "1cpal2zsm3zgi6f48vvwpg6wgkv42ndi7lk3zsg7sz52z83k61nz";
  };

  buildInputs = stdenv.lib.optional (!stdenv.isDarwin) alsaLib;

  configureFlags = stdenv.lib.optional
    (stdenv.hostPlatform ? mpg123)
    "--with-cpu=${stdenv.hostPlatform.mpg123.cpu}";

  meta = {
    description = "Fast console MPEG Audio Player and decoder library";
    homepage = http://mpg123.org;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.ftrvxmtrx ];
    platforms = stdenv.lib.platforms.unix;
  };
}
