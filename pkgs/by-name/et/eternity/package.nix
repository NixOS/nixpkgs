{
  lib,
  stdenv,
  cmake,
  libGL,
  SDL2,
  SDL2_mixer,
  SDL2_net,
  fetchFromGitHub,
  makeWrapper,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eternity-engine";
  version = "4.05.04";
  src = fetchFromGitHub {
    owner = "team-eternity";
    repo = "eternity";
    tag = finalAttrs.version;
    hash = "sha256-uUQYTI6qDMMtL0Zc82wr3hOPayvAj5kH8CuexAKFE6I=";
    fetchSubmodules = true;
  };

  postPatch =
    # CMake 4 compatibility
    ''
      substituteInPlace acsvm/CMakeLists.txt \
        --replace-fail 'cmake_minimum_required(VERSION 2.6)' 'cmake_minimum_required(VERSION 3.10)'

      substituteInPlace zlib/CMakeLists.txt \
        --replace-fail 'cmake_minimum_required(VERSION 2.4.4)' 'cmake_minimum_required(VERSION 3.10)'

      substituteInPlace snes_spc/CMakeLists.txt \
        --replace-fail 'CMAKE_MINIMUM_REQUIRED (VERSION 2.4)' 'cmake_minimum_required(VERSION 3.10)'

      substituteInPlace libpng/CMakeLists.txt \
        --replace-fail 'cmake_minimum_required(VERSION 3.1)' 'cmake_minimum_required(VERSION 3.10)' \
        --replace-fail 'cmake_policy(VERSION 3.1)' 'cmake_policy(VERSION 3.10)'

      substituteInPlace adlmidi/libADLMIDI.pc.in \
        --replace-fail 'libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@' 'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
        --replace-fail 'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' 'libdir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
    ''
    +
    # Find installed 'base' data directory
    ''
      substituteInPlace source/hal/i_directory.cpp \
        --replace-fail '/usr/local/share/eternity/base' "$out/share/eternity/base"
    '';

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    libGL
    SDL2
    SDL2_mixer
    SDL2_net
    zlib
  ];

  meta = {
    homepage = "https://doomworld.com/eternity";
    description = "New school Doom port by James Haley";
    mainProgram = "eternity";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aware70 ];
  };
})
