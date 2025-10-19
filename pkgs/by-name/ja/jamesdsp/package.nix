{
  copyDesktopItems,
  fetchFromGitHub,
  fetchpatch,
  glibmm,
  gst_all_1,
  lib,
  libarchive,
  makeDesktopItem,
  pipewire,
  pkg-config,
  pulseaudio,
  stdenv,
  usePipewire ? true,
  usePulseaudio ? false,
  kdePackages,
}:

assert lib.asserts.assertMsg (
  usePipewire != usePulseaudio
) "You need to enable one and only one of pulseaudio or pipewire support";

stdenv.mkDerivation (finalAttrs: {
  pname = "jamesdsp";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "Audio4Linux";
    repo = "JDSP4Linux";
    fetchSubmodules = true;
    tag = finalAttrs.version;
    hash = "sha256-eVndqIqJ3DRceuFMT++g2riXq0CL5r+TWbvzvaYIfZ8=";
  };

  nativeBuildInputs = [
    kdePackages.qmake
    pkg-config
    copyDesktopItems
    kdePackages.wrapQtAppsHook
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/Audio4Linux/JDSP4Linux/pull/241.patch";
      hash = "sha256-RtVKlw2ca8An4FodeD0RN95z9yHDHBgAxsEwLAmW7co=";
      name = "fix-build-with-new-pipewire.patch";
    })
    ./fix-build-on-qt6_9.diff
  ];

  buildInputs = [
    glibmm
    libarchive
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qtwayland
  ]
  ++ lib.optionals usePipewire [
    pipewire
  ]
  ++ lib.optionals usePulseaudio [
    pulseaudio
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
  ];

  preFixup = lib.optionalString usePulseaudio ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  qmakeFlags = lib.optionals usePulseaudio [ "CONFIG+=USE_PULSEAUDIO" ];

  # https://github.com/Audio4Linux/JDSP4Linux/issues/228
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=incompatible-pointer-types"
    "-Wno-error=implicit-int"
    "-Wno-error=implicit-function-declaration"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "jamesdsp";
      desktopName = "JamesDSP";
      genericName = "Audio effects processor";
      exec = "jamesdsp";
      icon = "jamesdsp";
      comment = "JamesDSP for Linux";
      categories = [
        "AudioVideo"
        "Audio"
      ];
      startupNotify = false;
      keywords = [
        "equalizer"
        "audio"
        "effect"
      ];
    })
  ];

  postInstall = ''
    install -D resources/icons/icon.png $out/share/pixmaps/jamesdsp.png
    install -D resources/icons/icon.svg $out/share/icons/hicolor/scalable/apps/jamesdsp.svg
  '';

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Audio effect processor for PipeWire clients";
    mainProgram = "jamesdsp";
    homepage = "https://github.com/Audio4Linux/JDSP4Linux";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      pasqui23
      wineee
    ];
    platforms = lib.platforms.linux;
  };
})
