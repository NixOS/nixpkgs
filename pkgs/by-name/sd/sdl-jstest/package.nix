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
<<<<<<< HEAD
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation {
  pname = "sdl-jstest";
<<<<<<< HEAD
  version = "0.2.2-unstable-2025-11-28";
=======
  version = "0.2.2-unstable-2025-03-27";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = "sdl-jstest";
<<<<<<< HEAD
    rev = "c3bb98945be0c6cb4ef54e9bbc1647a2b1bb4a6c";
    hash = "sha256-1+8KkQj8mHkPP2lsMR3vl38FuphRTseL356/KBsFzfw=";
=======
    rev = "917d27b3b45a335137bd2c8597f8bcf2bac8a569";
    hash = "sha256-lUHI72fcIEllbcieUrp9A/iKSjUHqmKOUXbzdXCV5jE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    homepage = "https://github.com/Grumbel/sdl-jstest";
    description = "Simple SDL joystick test application for the console";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      yuannan
    ];
=======
    maintainers = [ ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "sdl2-jstest";
  };
}
