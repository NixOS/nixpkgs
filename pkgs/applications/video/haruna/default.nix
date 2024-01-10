{ lib
, fetchFromGitLab
, mkDerivation
, breeze-icons
, breeze-qt5
, cmake
, extra-cmake-modules
, ffmpeg-headless
, kconfig
, kcoreaddons
, kfilemetadata
, ki18n
, kiconthemes
, kio
, kirigami2
, kxmlgui
, kdoctools
, mpv
, pkg-config
, wrapQtAppsHook
, qqc2-desktop-style
, qtbase
, qtquickcontrols2
, yt-dlp
}:

mkDerivation rec {
  pname = "haruna";
  version = "0.12.3";

  src = fetchFromGitLab {
    owner = "multimedia";
    repo = "haruna";
    rev = "v${version}";
    hash = "sha256-iYf8oTMQ65+6E1dlOj0GU6EezPul6p1GG2CcrcjDUik=";
    domain = "invent.kde.org";
  };

  postPatch = ''
    substituteInPlace src/application.cpp \
      --replace '"yt-dlp"' '"${lib.getExe yt-dlp}"'
  '';

  buildInputs = [
    breeze-icons
    breeze-qt5
    qqc2-desktop-style
    yt-dlp

    ffmpeg-headless
    kconfig
    kcoreaddons
    kfilemetadata
    ki18n
    kiconthemes
    kio
    kirigami2
    kxmlgui
    kdoctools
    mpv
    qtbase
    qtquickcontrols2
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
