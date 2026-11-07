{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "cdvd";
  version = "0-unstable-2026-09-19";

  src = fetchFromGitHub {
    owner = "Szmelc-INC";
    repo = "cdvd";
    rev = "5a6ff849a58e0923a86045bfd90067f8cb7f8d67";
    hash = "sha256-X3dRhW3/rvHOPD6SYT+7S3zLPC0GjYiru53gJUSq1BY=";
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
