{
  lib,
  SDL2,
  cmake,
  fetchFromGitHub,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_audiolib";
  version = "0-unstable-2022-04-17";

  src = fetchFromGitHub {
    owner = "realnc";
    repo = "SDL_audiolib";
    rev = "908214606387ef8e49aeacf89ce848fb36f694fc";
    hash = "sha256-11KkwIhG1rX7yDFSj92NJRO9L2e7XZGq2gOJ54+sN/A=";
  };

  nativeBuildInputs = [
    SDL2
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
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
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ ]);
    inherit (SDL2.meta) platforms;
  };
})
