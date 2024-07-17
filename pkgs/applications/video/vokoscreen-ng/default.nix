{
  fetchFromGitHub,
  gst_all_1,
  gst-plugins-bad,
  gst-plugins-base,
  gst-plugins-good,
  gst-plugins-ugly,
  gstreamer,
  lib,
  libX11,
  pipewire,
  pkg-config,
  pulseaudio,
  qt6,
  stdenv,
  wayland,
}:

stdenv.mkDerivation rec {
  pname = "vokoscreen-ng";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "vkohaupt";
    repo = "vokoscreenNG";
    rev = version;
    hash = "sha256-Y6+R18Gf3ShqhsmZ4Okx02fSOOyilS6iKU5FW9wpxvY=";
  };

  qmakeFlags = [ "src/vokoscreenNG.pro" ];

  nativeBuildInputs = [
    qt6.qttools
    pkg-config
    qt6.qmake
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    gst_all_1.gstreamer
    libX11
    pulseaudio
    qt6.qtbase
    qt6.qtmultimedia
    wayland
    pipewire
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  postPatch = ''
    substituteInPlace src/vokoscreenNG.pro \
      --replace lrelease-qt5 lrelease
  '';

  postInstall = ''
    mkdir -p $out/bin $out/share/applications $out/share/icons
    cp ./vokoscreenNG $out/bin/
    cp ./src/applications/vokoscreenNG.desktop $out/share/applications/
    cp ./src/applications/vokoscreenNG.png $out/share/icons/
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
    wrapQtApp $out/bin/vokoscreenNG
  '';

  meta = with lib; {
    description = "User friendly Open Source screencaster for Linux and Windows";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/vkohaupt/vokoscreenNG";
    maintainers = with maintainers; [
      shamilton
      dietmarw
    ];
    platforms = platforms.linux;
    mainProgram = "vokoscreenNG";
  };
}
