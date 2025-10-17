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
  libSM,
  libXext,
  libpng,
  freetype,
  libGLU,
  libGL,
  glew,
  glm,
  openal,
  libogg,
  libvorbis,
}:

stdenv.mkDerivation rec {
  pname = "supertux";
  version = "0.6.3";

  src = fetchurl {
    url = "https://github.com/SuperTux/supertux/releases/download/v${version}/SuperTux-v${version}-Source.tar.gz";
    sha256 = "1xkr3ka2sxp5s0spp84iv294i29s1vxqzazb6kmjc0n415h0x57p";
  };

  postPatch = ''
    sed '1i#include <memory>' -i external/partio_zip/zip_manager.hpp # gcc12
    # Fix build with cmake 4. Remove for version >= 0.6.4.
    # See <https://github.com/SuperTux/supertux/pull/3093>
    substituteInPlace CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 3.1)' \
      'cmake_minimum_required(VERSION 4.0)'
    substituteInPlace external/physfs/CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 2.8.12)' \
      'cmake_minimum_required(VERSION 4.0)'
    substituteInPlace external/sexp-cpp/CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 3.0)' \
      'cmake_minimum_required(VERSION 4.0)'
    substituteInPlace external/squirrel/CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 2.8)' \
      'cmake_minimum_required(VERSION 4.0)'
    substituteInPlace external/tinygettext/CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 2.4)' \
      'cmake_minimum_required(VERSION 4.0)'
    substituteInPlace external/SDL_ttf/CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 3.0)' \
      'cmake_minimum_required(VERSION 4.0)'
    substituteInPlace external/discord-sdk/CMakeLists.txt --replace-fail \
      'cmake_minimum_required (VERSION 3.2.0)' \
      'cmake_minimum_required (VERSION 4.0)'
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    boost
    curl
    SDL2
    SDL2_image
    libSM
    libXext
    libpng
    freetype
    libGL
    libGLU
    glew
    glm
    openal
    libogg
    libvorbis
  ];

  cmakeFlags = [ "-DENABLE_BOOST_STATIC_LIBS=OFF" ];

  postInstall = ''
    mkdir $out/bin
    ln -s $out/games/supertux2 $out/bin
  '';

  meta = with lib; {
    description = "Classic 2D jump'n run sidescroller game";
    homepage = "https://supertux.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
    mainProgram = "supertux2";
  };
}
