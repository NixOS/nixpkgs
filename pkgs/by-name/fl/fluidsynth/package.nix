{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  cmake,
  libjack2,
  libpulseaudio,
  libsndfile,
  pkg-config,
  testers,
  validatePkgConfig,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fluidsynth";
  version = "2.6.2";

  __structuredAttrs = true;
  strictDeps = true;

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
    cmake
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    libjack2
    libsndfile
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libpulseaudio
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SIGNALSMITH-LINEAR" "${finalAttrs.signalsmith.linear}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SIGNALSMITH-DSP" "${finalAttrs.signalsmith.dsp}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SIGNALSMITH-HILBERT" "${finalAttrs.signalsmith.hilbert}")
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin (lib.cmakeBool "enable-framework" false);

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  checkTarget = "check";

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

  passthru = {
    tests = {
      cmake-config = testers.hasCmakeConfigModules {
        package = finalAttrs.finalPackage;
        versionCheck = true;
      };
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
        versionCheck = true;
      };
    };
  };

  meta = {
    description = "Real-time software synthesizer based on the SoundFont 2 specifications";
    homepage = "https://www.fluidsynth.org";
    changelog = "https://github.com/FluidSynth/fluidsynth/blob/${finalAttrs.src.tag}/doc/wiki/ChangeLog.md";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      guylamar2006
    ];
    platforms = lib.platforms.unix;
    mainProgram = "fluidsynth";
    cmakeConfigModules = [ "FluidSynth" ];
    pkgConfigModules = [ "fluidsynth" ];
  };
})
