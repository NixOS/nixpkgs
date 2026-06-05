{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  boost,
  curl,
  SDL2,
  SDL2_image,
  libsm,
  libxext,
  libpng,
  freetype,
  libGLU,
  libGL,
  glew,
  glm,
  openal,
  libogg,
  libvorbis,
  physfs,
  fmt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "supertux";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/SuperTux/supertux/releases/download/v${finalAttrs.version}/SuperTux-v${finalAttrs.version}-Source.tar.gz";
    hash = "sha256-MvxbmbmZTtWOWDQdbyHekldks4ElbhCFkRNt5TvDHaU=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    boost
    curl
    SDL2
    SDL2_image
    libsm
    libxext
    libpng
    freetype
    libGL
    libGLU
    glew
    glm
    openal
    libogg
    libvorbis
    physfs
    fmt
  ];

  cmakeFlags = [ "-DENABLE_BOOST_STATIC_LIBS=OFF" ];

  postInstall = ''
    mkdir $out/bin
    ln -s $out/games/supertux2 $out/bin
  '';

  meta = {
    description = "Classic 2D jump'n run sidescroller game";
    homepage = "https://supertux.github.io/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = with lib.platforms; linux;
    mainProgram = "supertux2";
  };
})
