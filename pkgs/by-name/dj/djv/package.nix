{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  feather-tk,
  ffmpeg_7,
  freetype,
  glfw,
  imath,
  libGL,
  lunasvg,
  minizip-ng,
  nativefiledialog-extended,
  nlohmann_json,
  opencolorio,
  opentimelineio,
  plutovg,
  SDL2,
  tlrender,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "djv";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "grizzlypeak3d";
    repo = "djv";
    tag = finalAttrs.version;
    hash = "sha256-/SakJ23mi/dz8eUt2UtcgfLtFZiCHy1ME+jWdNS8+Fw=";
  };

  postPatch = ''
    substituteInPlace cmake/Modules/djvPackage.cmake \
      --replace-fail \
        ' ''${CMAKE_INSTALL_PREFIX}/etc/tlRender/LICENSE_' \
        " ${tlrender}/etc/tlRender/LICENSE_"
  '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    feather-tk
    ffmpeg_7
    freetype
    glfw
    imath
    tlrender
    libGL
    lunasvg
    minizip-ng
    nativefiledialog-extended
    nlohmann_json
    opencolorio
    opentimelineio
    plutovg
    SDL2
  ];

  # GLFW requires a working X11 session.
  doCheck = false;

  meta = {
    description = "Professional review software for VFX, animation, and film production";
    homepage = "https://darbyjohnston.github.io/DJV/";
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ blitz ];
    license = lib.licenses.bsd3;
    mainProgram = "djv";
  };
})
