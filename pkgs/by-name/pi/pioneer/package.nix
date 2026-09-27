{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  assimp,
  curl,
  freetype,
  #, glew
  libGL,
  libGLU,
  libpng,
  libsigcxx,
  libvorbis,
  libx11,
  lua5_2,
  libgbm,
  openal-soft,
  SDL2,
  SDL2_image,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pioneer";
  version = "20260907";

  src = fetchFromGitHub {
    owner = "pioneerspacesim";
    repo = "pioneer";
    rev = finalAttrs.version;
    hash = "sha256-2r8D2TbbxCiBN6CmBTT64C1Dc+/NhcZfSW7W1BfxUSE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    assimp
    curl
    freetype
    libGL
    libGLU
    libpng
    libsigcxx
    libvorbis
    libx11
    lua5_2
    libgbm
    openal-soft
    SDL2
    SDL2_image
  ];

  cmakeFlags = [
    "-DPIONEER_DATA_DIR:PATH=${placeholder "out"}/share/pioneer/data"
    "-DUSE_SYSTEM_LIBLUA:BOOL=YES"
  ];

  makeFlags = [
    "all"
    "build-data"
  ];

  meta = {
    description = "Space adventure game set in the Milky Way galaxy at the turn of the 31st century";
    homepage = "https://pioneerspacesim.net";
    license = with lib.licenses; [
      gpl3Only
      cc-by-sa-30
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
})
