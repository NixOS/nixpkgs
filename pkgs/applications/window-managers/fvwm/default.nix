{ autoreconfHook, enableGestures ? false, lib, stdenv, fetchFromGitHub
, pkg-config, cairo, fontconfig, freetype, libXft, libXcursor, libXinerama
, libXpm, libXt, librsvg, libpng, fribidi, perl, libstroke, readline, libxslt }:

stdenv.mkDerivation rec {
  pname = "fvwm";
  version = "2.6.9";

  src = fetchFromGitHub {
    owner = "fvwmorg";
    repo = pname;
    rev = version;
    sha256 = "14jwckhikc9n4h93m00pzjs7xm2j0dcsyzv3q5vbcnknp6p4w5dh";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [
    cairo
    fontconfig
    freetype
    libXft
    libXcursor
    libXinerama
    libXpm
    libXt
    librsvg
    libpng
    fribidi
    perl
    readline
    libxslt
  ] ++ lib.optional enableGestures libstroke;

  configureFlags = [ "--enable-mandoc" "--disable-htmldoc" ];

  meta = {
    homepage = "http://fvwm.org";
    description = "A multiple large virtual desktop window manager";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ edanaher ];
  };
}
