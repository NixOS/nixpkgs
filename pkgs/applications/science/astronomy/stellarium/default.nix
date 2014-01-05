{ stdenv, fetchurl, cmake, freetype, libpng, mesa, gettext, openssl, qt4, perl, libiconv }:

stdenv.mkDerivation rec {
  name = "stellarium-0.12.4";

  src = fetchurl {
    url = "mirror://sourceforge/stellarium/${name}.tar.gz";
    sha256 = "11367hv9niyz9v47lf31vjsqkgc8da0vy2nhiyxgmk1i49p1pbhg";
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
