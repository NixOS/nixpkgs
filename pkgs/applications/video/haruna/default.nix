{ lib
, stdenv
, fetchFromGitLab
, breeze-icons
, breeze
, cmake
, extra-cmake-modules
, ffmpeg-headless
, kconfig
, kcoreaddons
, kfilemetadata
, ki18n
, kiconthemes
, kio
, kirigami
, kxmlgui
, kdoctools
, mpvqt
, pkg-config
, wrapQtAppsHook
, qqc2-desktop-style
, qtbase
, yt-dlp
}:

stdenv.mkDerivation rec {
  pname = "haruna";
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "multimedia";
    repo = "haruna";
    rev = "v${version}";
    hash = "sha256-m4u1V+vp4wOSqRbdbxgxDNgC28biiB3A6w1pSfuczHs=";
    domain = "invent.kde.org";
  };

  postPatch = ''
    substituteInPlace src/application.cpp \
      --replace '"yt-dlp"' '"${lib.getExe yt-dlp}"'
  '';

  buildInputs = [
    breeze-icons
    breeze
    qqc2-desktop-style
    yt-dlp

    ffmpeg-headless
    kconfig
    kcoreaddons
    kfilemetadata
    ki18n
    kiconthemes
    kio
    kirigami
    kxmlgui
    kdoctools
    mpvqt
    qtbase
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/multimedia/haruna";
    description = "Open source video player built with Qt/QML and libmpv";
    license = with licenses; [ bsd3 cc-by-40 cc-by-sa-40 cc0 gpl2Plus gpl3Plus wtfpl ];
    maintainers = with maintainers; [ jojosch kashw2 ];
    mainProgram = "haruna";
  };
}
