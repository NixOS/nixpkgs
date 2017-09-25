{ gestures ? false
, stdenv, fetchurl, pkgconfig
, cairo, fontconfig, freetype, libXft, libXcursor, libXinerama
, libXpm, libXt, librsvg, libpng, fribidi, perl
, libstroke ? null
}:

assert gestures -> libstroke != null;

stdenv.mkDerivation rec {
  pname = "fvwm";
  version = "2.6.7";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/fvwmorg/fvwm/releases/download/${version}/${name}.tar.gz";
    sha256 = "01654d5abdcde6dac131cae9befe5cf6f01f9f7524d097c3b0f316e39f84ef73";
  };

  buildInputs = [
    pkgconfig cairo fontconfig freetype
    libXft libXcursor libXinerama libXpm libXt
    librsvg libpng fribidi perl
  ] ++ stdenv.lib.optional gestures libstroke;

  meta = {
    homepage = http://fvwm.org;
    description = "A multiple large virtual desktop window manager";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ edanaher ];
  };
}
