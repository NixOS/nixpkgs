{ stdenv, fetchurl, cmake, freetype, libpng, mesa, gettext, openssl, qt5, perl
, libiconv }:

stdenv.mkDerivation rec {
  name = "stellarium-0.13.2";

  src = fetchurl {
    url = "mirror://sourceforge/stellarium/${name}.tar.gz";
    sha256 = "1asrq1v6vjzxd2zz92brdfs5f5b1qf8zwd7k2dpg3dl4shl8wwg5";
  };

  buildInputs = [ cmake freetype libpng mesa gettext openssl qt5 perl libiconv ];

  enableParallelBuilding = true;

  meta = {
    description = "Free open-source planetarium";
    homepage = "http://stellarium.org/";
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux; # should be mesaPlatforms, but we don't have qt on darwin
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
