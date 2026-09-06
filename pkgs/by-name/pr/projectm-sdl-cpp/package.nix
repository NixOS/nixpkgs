{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  libprojectm,
  libGL,
  libx11,
  poco,
  utf8proc,
  SDL2,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "projectm-sdl-cpp";
  version = "2.0.0-pre1";

  src = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "frontend-sdl-cpp";
    tag = "${finalAttrs.version}";
    hash = "sha256-JCnvlX1pQeLsqI/74tBGKd2ONydABqulOZ8kghiDn8s=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    libprojectm
    poco
    utf8proc
    libGL
    libx11
    SDL2
  ];

  strictDeps = true;

  meta = {
    description = "Standalone application based on libprojectM and libSDL that turns your desktop audio into awesome visuals";
    homepage = "https://github.com/projectM-visualizer/frontend-sdl-cpp";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "projectMSDL";
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # TODO build probably needs some fixing
  };
})
