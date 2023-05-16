<<<<<<< HEAD
{ copyDesktopItems
, fetchFromGitHub
, glibmm
, gst_all_1
, lib
, libarchive
, makeDesktopItem
, pipewire
, pkg-config
, pulseaudio
, qmake
, qtbase
, qtsvg
, stdenv
, usePipewire ? true
, usePulseaudio ? false
, wrapQtAppsHook
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

assert lib.asserts.assertMsg (usePipewire != usePulseaudio) "You need to enable one and only one of pulseaudio or pipewire support";

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "jamesdsp";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "Audio4Linux";
    repo = "JDSP4Linux";
    fetchSubmodules = true;
    rev = finalAttrs.version;
    hash = "sha256-XYJl94/PstWG5qaBQ2rXc/nG9bDeP3Q62zDYHmZvPaw=";
=======
let
  pluginPath = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good ]);
in
  mkDerivation rec {
  pname = "jamesdsp";
  version = "2.4";
  src = fetchFromGitHub rec {
    owner = "Audio4Linux";
    repo = "JDSP4Linux";
    fetchSubmodules = true;
    rev = version;
    hash = "sha256-wD1JZQD8dR24cBN4QJCSrEsS4aoMD+MQmqnOIFKOeoE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  ] ++ lib.optionals usePipewire [
    pipewire
  ] ++ lib.optionals usePulseaudio [
=======
  ] ++ lib.optional usePipewire pipewire
  ++ lib.optionals usePulseaudio [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pulseaudio
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
  ];

<<<<<<< HEAD
  preFixup = lib.optionalString usePulseaudio ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';
=======
  qtWrapperArgs = lib.optionals usePulseaudio [ "--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${pluginPath}" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  meta = {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "An audio effect processor for PipeWire clients";
    homepage = "https://github.com/Audio4Linux/JDSP4Linux";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pasqui23 rewine ];
    platforms = lib.platforms.linux;
  };
})
=======
  meta = with lib;{
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "An audio effect processor for PipeWire clients";
    homepage = "https://github.com/Audio4Linux/JDSP4Linux";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ pasqui23 rewine ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
