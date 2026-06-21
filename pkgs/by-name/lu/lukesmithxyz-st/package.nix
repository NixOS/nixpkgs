{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  harfbuzz,
  libx11,
  libxext,
  libxft,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "lukesmithxyz-st";
  version = "0-unstable=2026-04-10";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = "st";
    rev = "48b8ee6e181643800fe83353ec554f503020a8fa";
    hash = "sha256-XFf48+6I3IHcRKGHRJIJb9u2sTKWyuWTb5lN+BILYYc=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    fontconfig
    harfbuzz
    libx11
    libxext
    libxft
    ncurses
  ];

  installPhase = ''
    runHook preInstall

    TERMINFO=$out/share/terminfo make install PREFIX=$out

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/LukeSmithxyz/st";
    description = "Luke Smith's fork of st";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
