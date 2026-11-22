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
  version = "4.06.00";
  src = fetchFromGitHub {
    owner = "team-eternity";
    repo = "eternity";
    tag = finalAttrs.version;
    hash = "sha256-+pk61n5xpWwx1+zFtfx0lfJ4T2woXWCIWSZkgwJmXuE=";
    fetchSubmodules = true;
  };

  postPatch =
    # Fix the paths in the installed libADLMIDI pkg-config file
    ''
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
