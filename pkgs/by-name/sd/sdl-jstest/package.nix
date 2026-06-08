{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  SDL2,
  ncurses,
  docbook_xsl,
  git,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "sdl-jstest";
  version = "0.2.2-unstable-2025-11-28";

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = "sdl-jstest";
    rev = "c3bb98945be0c6cb4ef54e9bbc1647a2b1bb4a6c";
    hash = "sha256-1+8KkQj8mHkPP2lsMR3vl38FuphRTseL356/KBsFzfw=";
    fetchSubmodules = true;
  };

  buildInputs = [
    SDL2
    ncurses
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    docbook_xsl
    git
  ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_SDL_JSTEST" false) ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://github.com/Grumbel/sdl-jstest";
    description = "Simple SDL joystick test application for the console";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      yuannan
    ];
    mainProgram = "sdl2-jstest";
  };
}
