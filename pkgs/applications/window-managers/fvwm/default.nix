{ gestures ? false
, stdenv, fetchurl, pkgconfig
, cairo, fontconfig, freetype, libXft, libXcursor, libXinerama
, libXpm, libXt, librsvg, libpng, fribidi, perl
, libstroke ? null
}:

assert gestures -> libstroke != null;

stdenv.mkDerivation rec {
  pname = "fvwm";
  version = "2.6.9";

  src = fetchurl {
    url = "https://github.com/fvwmorg/fvwm/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "1bliqcnap7vb3m2rn8wvxyfhbf35h9x34s41fl4301yhrkrlrihv";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cairo fontconfig freetype
    libXft libXcursor libXinerama libXpm libXt
    librsvg libpng fribidi perl
  ] ++ stdenv.lib.optional gestures libstroke;

  meta = {
    homepage = "http://fvwm.org";
    description = "A multiple large virtual desktop window manager";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ edanaher ];
  };
}
