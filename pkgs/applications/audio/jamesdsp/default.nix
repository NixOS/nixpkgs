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
, fetchpatch
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
  version = "2.3";
  src = fetchFromGitHub rec {
    owner = "Audio4Linux";
    repo = "JDSP4Linux";
    fetchSubmodules = true;
    rev = version;
    hash = "sha256-Hkzurr+s+vvSyOMCYH9kHI+nIm6mL9yORGNzY2FXslc=";
  };

  patches = [
    # fixing /usr install assumption, remove on version bump
    (fetchpatch {
      url = "https://github.com/Audio4Linux/JDSP4Linux/commit/003c9e9fc426f83e269aed6e05be3ed55273931a.patch";
      hash = "sha256-crll/a7C9pUq9eL5diq8/YgC5bNC6SrdijZEBxZpJ8E=";
    })
    # compatibility fix for PipeWire 0.3.44+, remove on version bump
    (fetchpatch {
      url = "https://github.com/Audio4Linux/JDSP4Linux/commit/e04c55735cc20fc3c3ce042c5681ec80f7df3c96.patch";
      hash = "sha256-o6AUtQzugykALSdkM3i3lYqRmzJX3FzmALSi0TrWuRA=";
    })
  ];

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

  meta = with lib;{
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "An audio effect processor for PipeWire clients";
    homepage = "https://github.com/Audio4Linux/JDSP4Linux";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ pasqui23 rewine ];
    platforms = platforms.linux;
  };
}
