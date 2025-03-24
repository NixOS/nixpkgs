{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libprojectm,
  poco,
  utf8proc,
  SDL2,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "projectm-sdl-cpp";
  version = "0-unstable-2025-02-28";

  src = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "frontend-sdl-cpp";
    rev = "9d93ead331553738568fb789d5e95bfb2388e953";
    hash = "sha256-ubylUiVVs7GqirWgawY3ruL/yyZIy8QNJ3wEdTc+4Pc=";
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
    SDL2
  ];

  # poco 1.14 requires c++17
  NIX_CFLAGS_COMPILE = [ "-std=gnu++17" ];

  strictDeps = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Standalone application based on libprojectM and libSDL that turns your desktop audio into awesome visuals";
    homepage = "https://github.com/projectM-visualizer/frontend-sdl-cpp";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "projectMSDL";
    platforms = lib.platforms.all;
  };
}
