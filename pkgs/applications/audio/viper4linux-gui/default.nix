{ lib
, stdenv
, fetchFromGitHub
, copyDesktopItems
, pkg-config
, qtbase
, qtsvg
, qtmultimedia
, qmake
, gst_all_1
, libpulseaudio
, makeDesktopItem
, viper4linux
, wrapQtAppsHook
}:
let
  gstPluginPath = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with gst_all_1; [ gstreamer gst-plugins-viperfx gst-plugins-base gst-plugins-good ]);
in
stdenv.mkDerivation rec {
  pname = "viper4linux-gui";
  version = "unstable-2022-04-23";

  src = fetchFromGitHub {
    owner = "Audio4Linux";
    repo = "Viper4Linux-GUI";
    rev = "2d0c84d7dda76c59e31c850e38120002eb779b7a";
    sha256 = "sha256-5YlLCF598i/sldczPEgCB+1KJDA7jqM964QDSNjgTKM=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "viper-gui";
      icon = "viper";
      desktopName = "viper4linux";
      genericName = "Equalizer";
      comment = meta.description;
      categories = [ "AudioVideo" "Audio" ];
      startupNotify = false;
    })
  ];

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    qtsvg
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-viperfx
    libpulseaudio
    viper4linux
  ];

  qmakeFlags = [ "V4L_Frontend.pro" ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ viper4linux gst_all_1.gstreamer ]}"
    "--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${gstPluginPath}"
  ];

  installPhase = ''
    runHook preInstalli
    install -D V4L_Frontend $out/bin/viper-gui
    install -D icons/viper.png $out/share/icons/viper.png
    runHook postInstall
  '';

  meta = with lib; {
    description = "Official UI for Viper4Linux2";
    homepage = "https://github.com/Audio4Linux/Viper4Linux-GUI";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ rewine ];
  };
}
