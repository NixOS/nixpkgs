{ lib
, stdenv
, fetchFromGitHub
, asciidoctor
, autoreconfHook
, cairo
, fontconfig
, freetype
, fribidi
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
, python3Packages
, readline
, sharutils
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fvwm3";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "fvwmorg";
    repo = "fvwm3";
    rev = finalAttrs.version;
    hash = "sha256-y1buTWO1vHzloh2e4EK1dkD0uQa7lIFUbNMkEe5x6Vo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    asciidoctor
    pkg-config
    python3Packages.wrapPython
  ];

  buildInputs = [
    cairo
    fontconfig
    freetype
    fribidi
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
    python3Packages.python
    readline
    sharutils
  ];

  pythonPath = [
    python3Packages.pyxdg
  ];

  configureFlags = [
    "--enable-mandoc"
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://fvwm.org";
    description = "A multiple large virtual desktop window manager - Version 3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (libX11.meta) platforms;
  };
})
