{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  runCommand,
  cmake,
  pkg-config,
  alsa-lib,
  fontconfig,
  freetype,
  git,
  gtkmm3,
  libjack2,
  libX11,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,

  buildVST3 ? true,
  buildStandalone ? true,
}:
let

  # Required version, base URL and expected location specified in cmake/CPM.cmake
  cpmDownloadVersion = "0.40.2";
  cpmSrc = fetchurl {
    url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v${cpmDownloadVersion}/CPM.cmake";
    hash = "sha256-yM3DLAOBZTjOInge1ylk3IZLKjSjENO3EEgSpcotg10=";
  };
  cpmSourceCache = runCommand "cpm-source-cache" { } ''
    mkdir -p $out/cpm
    ln -s ${cpmSrc} $out/cpm/CPM_${cpmDownloadVersion}.cmake
  '';
  vst3sdk = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = "vst3sdk";
    tag = "v3.7.7_build_19-patched";
    fetchSubmodules = true;
    hash = "sha256-LsPHPoAL21XOKmF1Wl/tvLJGzjaCLjaDAcUtDvXdXSU=";
  };
  rtaudioSrc = fetchFromGitHub {
    owner = "thestk";
    repo = "rtaudio";
    tag = "6.0.1";
    hash = "sha256-Acsxbnl+V+Y4mKC1gD11n0m03E96HMK+oEY/YV7rlIY=";
  };

  rtmidiSrc = fetchFromGitHub {
    owner = "thestk";
    repo = "rtmidi";
    tag = "6.0.0";
    hash = "sha256-QuUeFx8rPpe0+exB3chT6dUceDa/7ygVy+cQYykq7e0=";
  };

  toCMakeBoolean = v: if v then "ON" else "OFF";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "shortcircuit-xt";
  version = "unstable-2026-02-21";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "shortcircuit-xt";
    rev = "51b76845a6479734c96a3c3cc756a49d6c9e6222";
    fetchSubmodules = true;
    hash = "sha256-h01t6Adc0U4JDC6WwKwKE4dvCdX6r2rv3BYkK/wvz44=";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  nativeBuildInputs = [
    cmake
    pkg-config
    git
  ];

  buildInputs = [
    alsa-lib
    fontconfig
    freetype
    gtkmm3
    libjack2
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeFeature "CPM_SOURCE_CACHE" "${cpmSourceCache}")
    (lib.cmakeBool "CPM_LOCAL_PACKAGES_ONLY" true)
    (lib.cmakeFeature "VST3_SDK_ROOT" "${vst3sdk}")
    (lib.cmakeFeature "RTAUDIO_SDK_ROOT" "${rtaudioSrc}")
    (lib.cmakeFeature "RTMIDI_SDK_ROOT" "${rtmidiSrc}")
    (lib.cmakeFeature "GIT_COMMIT_HASH" finalAttrs.src.rev)
    (lib.cmakeFeature "GIT_COMMIT_DATE" "2026-01-16")

    (lib.cmakeFeature "SCXT_BUILD_STANDALONE" "${toCMakeBoolean buildStandalone}")
    (lib.cmakeFeature "SCXT_BUILD_VST3" "${toCMakeBoolean buildVST3}")
  ];

  # JUCE dlopen's these at runtime, crashes without them
  NIX_LDFLAGS = (
    toString [
      "-lX11"
      "-lXext"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
    ]
  );

  preConfigure = ''
    unset SOURCE_DATE_EPOCH
  '';

  meta = {
    description = "Will be a sampler when its done!";
    homepage = "https://github.com/surge-synthesizer/shortcircuit-xt";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      magnetophon
    ];
  };
})
