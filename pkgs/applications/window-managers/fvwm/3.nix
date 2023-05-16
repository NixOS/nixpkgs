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
<<<<<<< HEAD
  version = "1.0.7";
=======
  version = "1.0.6a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fvwmorg";
    repo = "fvwm3";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-CPEGwZuYDh0zDXVKLn806c4DfZZJVaMlmIsVAZl20S4=";
=======
    hash = "sha256-uYkIuMzhaWeCZm5aJF4oBYD72OLgwCBuUhDqpg6HQUM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
