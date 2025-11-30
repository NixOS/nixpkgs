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
  libX11,
  lua5_2,
  libgbm,
  SDL2,
  SDL2_image,
}:

stdenv.mkDerivation rec {
  pname = "pioneer";
  version = "20250501";

  src = fetchFromGitHub {
    owner = "pioneerspacesim";
    repo = "pioneer";
    rev = version;
    hash = "sha256-bQ1JGndHbBM28SuAUybo9msC/nBXu6el1UY41BKJN5A=";
  };

  postPatch = ''
    substituteInPlace contrib/lz4/CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 3.4)' 'cmake_minimum_required(VERSION 3.13)'
    substituteInPlace contrib/nanosockets/CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 3.1)' 'cmake_minimum_required(VERSION 3.13)'
  '';

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
    libX11
    lua5_2
    libgbm
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

  meta = with lib; {
    description = "Space adventure game set in the Milky Way galaxy at the turn of the 31st century";
    homepage = "https://pioneerspacesim.net";
    license = with licenses; [
      gpl3Only
      cc-by-sa-30
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
