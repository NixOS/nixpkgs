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
}:
mkDerivation rec {

  pname = "vokoscreen-ng";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "vkohaupt";
    repo = "vokoscreenNG";
    rev = version;
    sha256 = "1302663hyp2xxhaavhfky24a2p9gz23i3rykmrc6c1n23h24snri";
  };

  patches = [
    # Adaptation of previously used https://github.com/City-busz/vokoscreenNG/commit/0a3784095ecca582f7eb09551ceb34c309d83637 patch
    # used for 3.0.5 but incompatible at least since 3.0.8. The issue is addressed here https://github.com/vkohaupt/vokoscreenNG/issues/139
    ./linux-support-installation-target.patch
  ];

  qmakeFlags = [ "src/vokoscreenNG.pro" ];

  nativeBuildInputs = [ qttools pkg-config qmake ];
  buildInputs = [
    gstreamer
    libX11
    pulseaudio
    qtbase
    qtmultimedia
    qtx11extras

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
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "User friendly Open Source screencaster for Linux and Windows";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/vkohaupt/vokoscreenNG";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
