{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "cdvd";
  version = "0-unstable-2026-11-17";

  src = fetchFromGitHub {
    owner = "Szmelc-INC";
    repo = "cdvd";
    rev = "5e4d9e1267cfb63c90d803b09eeaf4483a9eb1a5";
    hash = "sha256-p0K1sUtS31kohW5v1uRwQkr5ZPFp66U6SaN+erybBFU=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [ ncurses ];

  installFlags = [ "BINDIR=$(out)/bin" ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Eyecandy screensaver";
    longDescription = ''
      A tiny C/ncurses eye candy for the command line.  It draws a
      bouncing DVD logo with a few extra features.
    '';
    homepage = "https://github.com/Szmelc-INC/cdvd";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "cdvd";
    platforms = lib.platforms.all;
  };
}
