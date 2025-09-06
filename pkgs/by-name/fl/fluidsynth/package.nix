{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPackages,
  pkg-config,
  cmake,
  alsa-lib,
  glib,
  libjack2,
  libsndfile,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fluidsynth";
  version = "2.4.7";

  src = fetchFromGitHub {
    owner = "FluidSynth";
    repo = "fluidsynth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z7DIX8KpPdtEHEMoxH7ewW32aXm27gfmWPZawwITyRQ=";
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
    glib
    libsndfile
    libjack2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libpulseaudio
  ];

  cmakeFlags = [
    "-Denable-framework=off"
  ];

  meta = {
    description = "Real-time software synthesizer based on the SoundFont 2 specifications";
    homepage = "https://www.fluidsynth.org";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.unix;
    mainProgram = "fluidsynth";
  };
})
