{ stdenv, fetchurl, cmake, freetype, libpng, mesa, gettext, openssl, perl, libiconv
, qtscript, qtserialport, qttools
}:

stdenv.mkDerivation rec {
  name = "stellarium-0.14.2";

  src = fetchurl {
    url = "mirror://sourceforge/stellarium/${name}.tar.gz";
    sha256 = "1xxil0rv61zc08znfv83cpsc47y1gjl2f3njhz0pn5zd8jpaa15a";
  };

  buildInputs = [
    cmake freetype libpng mesa gettext openssl perl libiconv qtscript
    qtserialport qttools
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Free open-source planetarium";
    homepage = "http://stellarium.org/";
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux; # should be mesaPlatforms, but we don't have qt on darwin
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
