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
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "fvwmorg";
    repo = "fvwm3";
    rev = finalAttrs.version;
    hash = "sha256-/2Ssl/sgKCXbUCtKj2WIcvEC3B16h5/1Jp87AggKxJo=";
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
