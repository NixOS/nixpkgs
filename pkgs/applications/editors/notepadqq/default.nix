{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  qttools,
  wrapQtAppsHook,
  libuchardet,
  qtbase,
  qtsvg,
  qtwebengine,
  qtwebsockets,
}:

stdenv.mkDerivation rec {
  pname = "notepadqq";
  # shipping a beta build as there's no proper release which supports qtwebengine
  version = "2.0.0-beta";

  src = fetchFromGitHub {
    owner = "notepadqq";
    repo = "notepadqq";
    rev = "v${version}";
    sha256 = "sha256-XA9Ay9kJApY+bDeOf0iPv+BWYFuTmIuqsLEPgRTCZCE=";
  };

  patches = [
    # Fix: chmod in the Makefile fails randomly
    # Move it to preFixup instead
    ./fix-configure.patch
  ];

  nativeBuildInputs = [
    pkg-config
    which
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    libuchardet
    qtbase
    qtsvg
    qtwebengine
    qtwebsockets
  ];

  strictDeps = false; # breaks qmake

  preConfigure = ''
    export LRELEASE="lrelease"
  '';

  dontWrapQtApps = true;

  preFixup = ''
    chmod +x $out/bin/notepadqq
    wrapQtApp $out/bin/notepadqq
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://notepadqq.com/";
    description = "Notepad++-like editor for the Linux desktop";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.rszibele ];
    mainProgram = "notepadqq";
  };
}
