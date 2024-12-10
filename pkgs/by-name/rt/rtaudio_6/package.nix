{
  stdenv,
  lib,
  config,
  fetchFromGitHub,
  testers,
  cmake,
  pkg-config,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  libpulseaudio,
  jackSupport ? true,
  libjack2,
  coreaudioSupport ? stdenv.hostPlatform.isDarwin,
  darwin,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtaudio";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtaudio";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-Acsxbnl+V+Y4mKC1gD11n0m03E96HMK+oEY/YV7rlIY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    validatePkgConfig
  ];

  buildInputs =
    lib.optionals alsaSupport [
      alsa-lib
    ]
    ++ lib.optionals pulseaudioSupport [
      libpulseaudio
    ]
    ++ lib.optionals jackSupport [
      libjack2
    ]
    ++ lib.optionals coreaudioSupport [
      darwin.apple_sdk.frameworks.CoreAudio
    ];

  cmakeFlags = [
    (lib.cmakeBool "RTAUDIO_API_ALSA" alsaSupport)
    (lib.cmakeBool "RTAUDIO_API_PULSE" pulseaudioSupport)
    (lib.cmakeBool "RTAUDIO_API_JACK" jackSupport)
    (lib.cmakeBool "RTAUDIO_API_CORE" coreaudioSupport)
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "A set of C++ classes that provide a cross platform API for realtime audio input/output";
    homepage = "https://www.music.mcgill.ca/~gary/rtaudio/";
    changelog = "https://github.com/thestk/rtaudio/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [
      "rtaudio"
    ];
  };
})
