{stdenv, fetchurl, cmake, freetype, libpng, mesa, gettext, openssl, qt4, perl, libiconv}:

let
  name = "stellarium-0.11.0";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/stellarium/${name}.tar.gz";
    sha256 = "dbedf47dd0744fb325d67d63d1279101be7f4259af2a5e8027f1072012dd2587";
  };

  buildInputs = [ cmake freetype libpng mesa gettext openssl qt4 perl libiconv ];

  cmakeFlags = "-DINTL_INCLUDE_DIR= -DINTL_LIBRARIES=";
  preConfigure = ''
    sed -i -e '/typedef void (\*__GLXextFuncPtr)(void);/d' src/core/external/GLee.h
  '';

  enableParallelBuilding = true;

  meta = {
    description = "an free open source planetarium";
    homepage = http://stellarium.org/;
    license = "GPL2";

    platforms = stdenv.lib.platforms.linux; # should be mesaPlatforms, but we don't have qt on darwin
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
