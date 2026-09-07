{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  glew,
  glm,
  libGLU,
  libGL,
  libx11,
  libxext,
  libxrender,
  icu74,
  libsm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slop";
  version = "7.7";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "slop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oUvzkIGrUTLVLR9Jf//Wh7AmnaNS2JLC3vXWg+w5W6g=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glew
    glm
    libGLU
    libGL
    libx11
    libxext
    libxrender
    icu74
    libsm
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Queries for a selection from the user and prints the region to stdout";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "slop";
  };
})
