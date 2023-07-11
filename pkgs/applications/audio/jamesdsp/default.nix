{ stdenv
, lib
, mkDerivation
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

let
  pluginPath = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good ]);
in
  mkDerivation rec {
  pname = "jamesdsp";
  version = "2.5.1";
  src = fetchFromGitHub rec {
    owner = "Audio4Linux";
    repo = "JDSP4Linux";
    fetchSubmodules = true;
    rev = version;
    hash = "sha256-osbRiUa/CKq4l3pV2MZYKcECEfa1ee3SAQ8RsiimbA4=";
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

  qtWrapperArgs = lib.optionals usePulseaudio [ "--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${pluginPath}" ];

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
