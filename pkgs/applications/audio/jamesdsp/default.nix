{
  copyDesktopItems,
  fetchFromGitHub,
  glibmm,
  gst_all_1,
  lib,
  libarchive,
  makeDesktopItem,
  pipewire,
  pkg-config,
  pulseaudio,
  qmake,
  qtbase,
  qtsvg,
  stdenv,
  usePipewire ? true,
  usePulseaudio ? false,
  wrapQtAppsHook,
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
    rev = finalAttrs.version;
    hash = "sha256-eVndqIqJ3DRceuFMT++g2riXq0CL5r+TWbvzvaYIfZ8=";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    copyDesktopItems
    wrapQtAppsHook
  ];

  buildInputs =
    [
      glibmm
      libarchive
      qtbase
      qtsvg
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
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "An audio effect processor for PipeWire clients";
    mainProgram = "jamesdsp";
    homepage = "https://github.com/Audio4Linux/JDSP4Linux";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      pasqui23
      rewine
    ];
    platforms = lib.platforms.linux;
  };
})
