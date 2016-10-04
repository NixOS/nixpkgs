{ gestures ? false
, stdenv, fetchurl, pkgconfig
, cairo, fontconfig, freetype, libXft, libXcursor, libXinerama
, libXpm, libXt, librsvg, libpng, fribidi, perl
, libstroke ? null
}:

assert gestures -> libstroke != null;

stdenv.mkDerivation rec {
  name = "fvwm-2.6.6";

  src = fetchurl {
    url = "https://github.com/fvwmorg/fvwm/releases/download/version-2_6_6/${name}.tar.gz";
    sha256 = "c5de085ff25b2128a401a80225481e63335f815f84eea139f80a5f66e606dc2c";
  };

  buildInputs = [
    pkgconfig cairo fontconfig freetype
    libXft libXcursor libXinerama libXpm libXt
    librsvg libpng fribidi perl
  ] ++ stdenv.lib.optional gestures libstroke;

  meta = {
    homepage = "http://fvwm.org";
    description = "A multiple large virtual desktop window manager";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
