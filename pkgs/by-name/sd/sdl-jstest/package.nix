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
  version = "0.2.2-unstable-2026-07-03";

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = "sdl-jstest";
    rev = "b8eae565aefa8f1723eb0a64be94de309525d204";
    hash = "sha256-kS1FcoRUInVkksI2SKQ5oCnEYSZzpf3X+db1KmRzJwI=";
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
