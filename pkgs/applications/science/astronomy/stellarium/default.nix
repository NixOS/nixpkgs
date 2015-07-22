{ stdenv, fetchurl, cmake, freetype, libpng, mesa, gettext, openssl, qt5Full, perl, libiconv }:

stdenv.mkDerivation rec {
  name = "stellarium-0.13.3";

  src = fetchurl {
    url = "mirror://sourceforge/stellarium/${name}.tar.gz";
    sha256 = "1ml6z2xda4vx61agdz54x8fw1b115gwc7rcy0zhz1jh6g5jvf0ij";
  };

  buildInputs = [ cmake freetype libpng mesa gettext openssl perl libiconv qt5Full ];

  enableParallelBuilding = true;

  meta = {
    description = "Free open-source planetarium";
    homepage = "http://stellarium.org/";
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux; # should be mesaPlatforms, but we don't have qt on darwin
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
