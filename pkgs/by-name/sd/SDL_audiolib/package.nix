{
  lib,
  SDL2,
  cmake,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  flac,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_audiolib";
  # don't update to latest master as it will break some sounds in devilutionx
  version = "0-unstable-2022-07-13";

  src = fetchFromGitHub {
    owner = "realnc";
    repo = "SDL_audiolib";
    rev = "cc1bb6af8d4cf5e200259072bde1edd1c8c5137e";
    hash = "sha256-xP7qlwwOkqVeTlCEZLinnvmx8LbU2co5+t//cf4n190=";
  };

  nativeBuildInputs = [
    SDL2
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    flac
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "USE_DEC_ADLMIDI" false)
    (lib.cmakeBool "USE_DEC_BASSMIDI" false)
    (lib.cmakeBool "USE_DEC_DRFLAC" false)
    (lib.cmakeBool "USE_DEC_FLUIDSYNTH" false)
    (lib.cmakeBool "USE_DEC_LIBOPUSFILE" false)
    (lib.cmakeBool "USE_DEC_LIBVORBIS" false)
    (lib.cmakeBool "USE_DEC_MODPLUG" false)
    (lib.cmakeBool "USE_DEC_MPG123" false)
    (lib.cmakeBool "USE_DEC_MUSEPACK" false)
    (lib.cmakeBool "USE_DEC_OPENMPT" false)
    (lib.cmakeBool "USE_DEC_SNDFILE" false)
    (lib.cmakeBool "USE_DEC_WILDMIDI" false)
    (lib.cmakeBool "USE_DEC_XMP" false)
    (lib.cmakeBool "USE_RESAMP_SOXR" false)
    (lib.cmakeBool "USE_RESAMP_SRC" false)
  ];

  meta = {
    description = "Audio decoding, resampling and mixing library for SDL";
    homepage = "https://github.com/realnc/SDL_audiolib";
    license = lib.licenses.lgpl3Plus;
    teams = [ lib.teams.sdl ];
    inherit (SDL2.meta) platforms;
  };
})
