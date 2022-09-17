{ lib
, stdenv
, fetchFromGitHub
, asciidoctor
, autoreconfHook
, cairo
, fontconfig
, freetype
, fribidi
, imlib
, libSM
, libX11
, libXcursor
, libXft
, libXi
, libXinerama
, libXpm
, libXrandr
, libXt
, libevent
, libintl
, libpng
, librsvg
, libstroke
, libxslt
, perl
, pkg-config
, python3
, readline
, sharutils
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fvwm3";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "fvwmorg";
    repo = "fvwm3";
    rev = finalAttrs.version;
    hash = "sha256-ByMSX4nwXkp+ly39C2+cYy3e9B0vnGcJlyIiS7V6zoI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    asciidoctor
    pkg-config
  ];

  buildInputs = [
    cairo
    fontconfig
    freetype
    fribidi
    imlib
    libSM
    libX11
    libXcursor
    libXft
    libXi
    libXinerama
    libXpm
    libXrandr
    libXt
    libevent
    libintl
    libpng
    librsvg
    libstroke
    libxslt
    perl
    python3
    readline
    sharutils
  ];

  configureFlags = [
    "--enable-mandoc"
  ];

  meta = with lib; {
    homepage = "http://fvwm.org";
    description = "A multiple large virtual desktop window manager - Version 3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (libX11.meta) platforms;
  };
})
