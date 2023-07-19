{ stdenv
, lib
, fetchFromGitHub
, pipewire
, pulseaudio
, gst_all_1
, glibmm
, qmake
, qtbase
, qtsvg
, wrapQtAppsHook
, makeDesktopItem
, pkg-config
, libarchive
, copyDesktopItems
, usePipewire ? true
, usePulseaudio ? false
}:

assert lib.asserts.assertMsg (usePipewire != usePulseaudio) "You need to enable one and only one of pulseaudio or pipewire support";

stdenv.mkDerivation rec {
  pname = "jamesdsp";
  version = "2.6.0";

  src = fetchFromGitHub rec {
    owner = "Audio4Linux";
    repo = "JDSP4Linux";
    fetchSubmodules = true;
    rev = version;
    hash = "sha256-pogBpmGlqQnkXMdp5HbMYISjwMJalSPvEV9MDHj8aec=";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    copyDesktopItems
    wrapQtAppsHook
  ];

  buildInputs = [
    glibmm
    libarchive
    qtbase
    qtsvg
  ] ++ lib.optional usePipewire pipewire
  ++ lib.optionals usePulseaudio [
    pulseaudio
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
  ];

  preFixup = lib.optionals usePulseaudio ''
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
      categories = [ "AudioVideo" "Audio" ];
      startupNotify = false;
      keywords = [ "equalizer" "audio" "effect" ];
    })
  ];

  postInstall = ''
    install -D resources/icons/icon.png $out/share/pixmaps/jamesdsp.png
    install -D resources/icons/icon.svg $out/share/icons/hicolor/scalable/apps/jamesdsp.svg
  '';

  meta = with lib;{
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "An audio effect processor for PipeWire clients";
    homepage = "https://github.com/Audio4Linux/JDSP4Linux";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ pasqui23 rewine ];
    platforms = platforms.linux;
  };
}
