{ gestures ? false
, lib, stdenv, fetchurl, pkg-config
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

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cairo fontconfig freetype
    libXft libXcursor libXinerama libXpm libXt
    librsvg libpng fribidi perl
  ] ++ lib.optional gestures libstroke;

  meta = {
    homepage = "http://fvwm.org";
    description = "A multiple large virtual desktop window manager";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ edanaher ];
  };
}
