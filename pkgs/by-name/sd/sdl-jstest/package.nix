{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  SDL,
  SDL2,
  ncurses,
  docbook_xsl,
  git,
}:

stdenv.mkDerivation {
  pname = "sdl-jstest";
  version = "0.2.2-unstable-2025-03-27";

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = "sdl-jstest";
    rev = "917d27b3b45a335137bd2c8597f8bcf2bac8a569";
    hash = "sha256-lUHI72fcIEllbcieUrp9A/iKSjUHqmKOUXbzdXCV5jE=";
    fetchSubmodules = true;
  };

  buildInputs = [
    SDL
    SDL2
    ncurses
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
    docbook_xsl
    git
  ];

  meta = with lib; {
    homepage = "https://github.com/Grumbel/sdl-jstest";
    description = "Simple SDL joystick test application for the console";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
