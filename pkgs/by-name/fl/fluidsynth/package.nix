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
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "FluidSynth";
    repo = "fluidsynth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gTkW2X7fcmxJwYf13Yma6cBigz4sbsb99dBSYTDlcyY=";
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
    "-Dosal=cpp11"
    "-Denable-libinstpatch=0"
  ];

  meta = {
    description = "Real-time software synthesizer based on the SoundFont 2 specifications";
    homepage = "https://www.fluidsynth.org";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      lovek323
      guylamar2006
    ];
    platforms = lib.platforms.unix;
    mainProgram = "fluidsynth";
  };
})
