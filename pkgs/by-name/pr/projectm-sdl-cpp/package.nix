{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libprojectm,
  libGL,
  libx11,
  poco,
  utf8proc,
  SDL2,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "projectm-sdl-cpp";
  version = "2.0.0-pre1-unstable-2026-04-07";

  src = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "frontend-sdl-cpp";
    rev = "86885bef2e2d7b7b0a6f13180309cf893b5bb5b0";
    hash = "sha256-JCnvlX1pQeLsqI/74tBGKd2ONydABqulOZ8kghiDn8s=";
    fetchSubmodules = true;
  };

  # Probably an artifact of the vcpkg package
  postPatch = ''
    substituteInPlace ImGui.cmake \
      --replace-fail "SDL2::SDL2main" ""
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "SDL2::SDL2main" ""
  '';

  cmakeFlags = [
    # Doesn't seem to be present in the source tree, so the installation fails if enabled
    (lib.cmakeBool "ENABLE_DESKTOP_ICON" false)
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libprojectm
    poco
    utf8proc
    libGL
    libx11
    SDL2
  ];

  # poco 1.14 requires c++17
  env.NIX_CFLAGS_COMPILE = toString [ "-std=gnu++17" ];

  strictDeps = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Standalone application based on libprojectM and libSDL that turns your desktop audio into awesome visuals";
    homepage = "https://github.com/projectM-visualizer/frontend-sdl-cpp";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "projectMSDL";
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # TODO build probably needs some fixing
  };
}
