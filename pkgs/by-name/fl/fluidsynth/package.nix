{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPackages,
  pkg-config,
  cmake,
  alsa-lib,
  libjack2,
  libsndfile,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fluidsynth";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "FluidSynth";
    repo = "fluidsynth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8GxDpapeYIHPRFdfhKipym23x6ARG1aOAVJ0YWir0JI=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    buildPackages.stdenv.cc
    pkg-config
    cmake
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    libsndfile
    libjack2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libpulseaudio
  ];

  cmakeFlags = [
    "-Denable-framework=off"
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SIGNALSMITH-LINEAR" "${finalAttrs.signalsmith.linear}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SIGNALSMITH-DSP" "${finalAttrs.signalsmith.dsp}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SIGNALSMITH-HILBERT" "${finalAttrs.signalsmith.hilbert}")
  ];

  signalsmith = {
    dsp = fetchFromGitHub {
      owner = "Signalsmith-Audio";
      repo = "dsp";
      tag = "v1.7.1";
      hash = "sha256-6TCk3PDJApVnzv6YYDMlqEt5ydmEvYJWmcE8LrD0XEg=";
    };
    hilbert = fetchFromGitHub {
      owner = "Signalsmith-Audio";
      repo = "hilbert-iir";
      tag = "1.0.0";
      hash = "sha256-QSwj1hNdR60GK446jdlH7PPc5HEjmXihZdUfW/ZSC04=";
    };
    linear = fetchFromGitHub {
      owner = "Signalsmith-Audio";
      repo = "linear";
      tag = "0.3.1";
      hash = "sha256-m8zQJeZCQcHIwcGq17F2bmuZc4g7mFsxzRCUEpUrkr4=";
    };
  };

  meta = {
    changelog = "https://github.com/FluidSynth/fluidsynth/blob/${finalAttrs.src.tag}/doc/wiki/ChangeLog.md";
    description = "Real-time software synthesizer based on the SoundFont 2 specifications";
    homepage = "https://www.fluidsynth.org";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      guylamar2006
    ];
    platforms = lib.platforms.unix;
    mainProgram = "fluidsynth";
  };
})
