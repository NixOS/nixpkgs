{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  SDL2_mixer,
  buildOpenGLES ? false,
}:

stdenv.mkDerivation {
  pname = "rigel-engine";
  version = "0-unstable-2024-05-26";

  src = fetchFromGitHub {
    owner = "lethal-guitar";
    repo = "RigelEngine";
    rev = "f05996f9b3ad3b3ea5bb818e49e7977636746343";
    hash = "sha256-iZ+eYZxnVqHo4vLeZdoV7TO3fWivCfbAf4F57/fU7aY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
  ];

  cmakeFlags = [
    "-Wno-dev"
  ] ++ lib.optional buildOpenGLES "-DUSE_GL_ES=ON";

  meta = {
    description = "Modern re-implementation of the classic DOS game Duke Nukem II";
    homepage = "https://github.com/lethal-guitar/RigelEngine";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "RigelEngine";
    platforms = lib.platforms.all;
  };
}
