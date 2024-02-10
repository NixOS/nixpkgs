{ lib
, mkDerivation
, fetchFromGitHub
, pkg-config
, qmake
, qttools
, gstreamer
, libX11
, pulseaudio
, qtbase
, qtmultimedia
, qtx11extras

, gst-plugins-base
, gst-plugins-good
, gst-plugins-bad
, gst-plugins-ugly
, wayland
, pipewire
, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "vokoscreen-ng";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "vkohaupt";
    repo = "vokoscreenNG";
    rev = version;
    sha256 = "sha256-4tQ/fLaAbjfc3mt2qJsW9scku/CGUs74SehDaZgLPj4=";
  };

  qmakeFlags = [ "src/vokoscreenNG.pro" ];

  nativeBuildInputs = [ qttools pkg-config qmake wrapQtAppsHook ];
  buildInputs = [
    gstreamer
    libX11
    pulseaudio
    qtbase
    qtmultimedia
    qtx11extras
    wayland
    pipewire
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
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
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
    mainProgram = "vokoscreenNG";
  };
}
