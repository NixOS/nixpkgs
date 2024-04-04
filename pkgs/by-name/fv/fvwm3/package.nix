{ lib
, asciidoctor
, autoreconfHook
, cairo
, fetchFromGitHub
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
, stdenv
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
    (lib.enableFeature true "mandoc")
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  enableParallelBuilding = true;

  strictDeps = true;

  meta = {
    homepage = "http://fvwm.org";
    description = "A multiple large virtual desktop window manager - Version 3";
    longDescription = ''
      Fvwm is a virtual window manager for the X windows system. It was
      originally a feeble fork of TWM by Robert Nation in 1993 (fvwm history),
      and has evolved into the fantastic, fabulous, famous, flexible, and so on,
      window manager we have today.

      Fvwm is a ICCCM/EWMH compliant and highly configurable floating window
      manager built primarily using Xlib. Fvwm is configured using a
      configuration file, which is used to configure most aspects of the window
      manager including window looks, key bindings, menus, window behavior,
      additional modules, and more. There is a default configuration file that
      can be used as a starting point for writing one's own configuration file.

      Fvwm is a light weight window manager and can be configured to be anything
      from a small sleek window manager to a full featured desktop
      environment. To get the most out of fvwm, one should be willing to read
      the documents, and take the time to write a custom configuration file that
      suites their needs. The manual pages and the fvwm wiki can be used to help
      learn how to configure fvwm.
    '';
    changelog = "https://github.com/fvwmorg/fvwm3/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (libX11.meta) platforms;
  };
})
