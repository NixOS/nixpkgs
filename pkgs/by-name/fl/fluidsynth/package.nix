{
  lib,
  stdenv,
  fetchFromGitHub,
  _experimental-update-script-combinators,
  alsa-lib,
  cmake,
  dbus,
  ladspa-header,
  libjack2,
  libpulseaudio,
  libsndfile,
  nix-update-script,
  pipewire,
  pkg-config,
  testers,
  validatePkgConfig,
  versionCheckHook,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fluidsynth";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "FluidSynth";
    repo = "fluidsynth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8rOaZHEhKsh5N/2xMxYkxOqj4rI0G4O0HCklv3+RxSg=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    ladspa-header
    libjack2
    libsndfile
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    dbus
    libpulseaudio
  ]
  ++ lib.optional pipewireSupport pipewire;

  cmakeFlags = [
    (lib.cmakeBool "enable-framework" false)
    (lib.cmakeBool "enable-pipewire" pipewireSupport)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SIGNALSMITH-LINEAR" finalAttrs.passthru.signalsmith-linear.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SIGNALSMITH-DSP" finalAttrs.passthru.signalsmith-dsp.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SIGNALSMITH-HILBERT" finalAttrs.passthru.signalsmith-hilbert.outPath)
  ];

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    signalsmith-dsp = fetchFromGitHub {
      owner = "Signalsmith-Audio";
      repo = "dsp";
      tag = "v1.7.1";
      hash = "sha256-6TCk3PDJApVnzv6YYDMlqEt5ydmEvYJWmcE8LrD0XEg=";
    };

    signalsmith-hilbert = fetchFromGitHub {
      owner = "Signalsmith-Audio";
      repo = "hilbert-iir";
      tag = "1.0.0";
      hash = "sha256-QSwj1hNdR60GK446jdlH7PPc5HEjmXihZdUfW/ZSC04=";
    };

    signalsmith-linear = fetchFromGitHub {
      owner = "Signalsmith-Audio";
      repo = "linear";
      tag = "0.3.1";
      hash = "sha256-m8zQJeZCQcHIwcGq17F2bmuZc4g7mFsxzRCUEpUrkr4=";
    };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };

    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      {
        command = [ ./update-signalsmith.sh ];
        supportedFeatures = [ ];
      }
    ];
  };

  meta = {
    description = "Real-time software synthesizer based on the SoundFont 2 specifications";
    homepage = "https://www.fluidsynth.org";
    changelog = "https://github.com/FluidSynth/fluidsynth/blob/${finalAttrs.src.tag}/doc/wiki/ChangeLog.md";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      guylamar2006
      keenanweaver
    ];
    platforms = lib.platforms.unix;
    mainProgram = "fluidsynth";
    pkgConfigModules = [ "fluidsynth" ];
  };
})
