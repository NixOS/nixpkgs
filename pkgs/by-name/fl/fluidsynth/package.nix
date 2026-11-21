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
  readline,
  sdl3,
  systemdLibs,
  testers,
  validatePkgConfig,
  versionCheckHook,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  dbusSupport ? stdenv.hostPlatform.isLinux,
  jackSupport ? true,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  pulseaudioSupport ? stdenv.hostPlatform.isLinux,
  # GPL, and linked into libfluidsynth rather than just the CLI
  readlineSupport ? false,
  sdl3Support ? false,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
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
    hash = "sha256-xKFWwgkc0s0m1A8y6+rDlYWiOnYnOGp5sADOQpurNm0=";
    fetchSubmodules = true;
    postFetch = "rm -rf $out/test/manual"; # ~450 MB of manual test data
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
    ladspa-header
    libsndfile
  ]
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional dbusSupport dbus
  ++ lib.optional jackSupport libjack2
  ++ lib.optional pipewireSupport pipewire
  ++ lib.optional pulseaudioSupport libpulseaudio
  ++ lib.optional readlineSupport readline
  ++ lib.optional sdl3Support sdl3
  ++ lib.optional systemdSupport systemdLibs;

  cmakeFlags = [
    (lib.cmakeBool "enable-alsa" alsaSupport)
    (lib.cmakeBool "enable-dbus" dbusSupport)
    (lib.cmakeBool "enable-jack" jackSupport)
    (lib.cmakeBool "enable-pipewire" pipewireSupport)
    (lib.cmakeBool "enable-pulseaudio" pulseaudioSupport)
    (lib.cmakeBool "enable-readline" readlineSupport)
    (lib.cmakeBool "enable-sdl3" sdl3Support)
    (lib.cmakeBool "enable-systemd" systemdSupport)
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
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      ./update-signalsmith.sh
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
    cmakeConfigModules = [ "FluidSynth" ];
    pkgConfigModules = [ "fluidsynth" ];
  };
})
