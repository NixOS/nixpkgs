{stdenv, fetchurl, cmake, freetype, libpng, mesa, gettext, openssl, qt4, perl, libiconv}:

let
  name = "stellarium-0.11.4a";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/stellarium/${name}.tar.gz";
    sha256 = "0gs3lf2061chgcyx22xbnn6b284nsnj8xal7jyjzj57s8yk4n619";
  };

  buildInputs = [ cmake freetype libpng mesa gettext openssl qt4 perl libiconv ];

  enableParallelBuilding = true;

  meta = {
    description = "Free open-source planetarium";
    homepage = "http://stellarium.org/";
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux; # should be mesaPlatforms, but we don't have qt on darwin
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
