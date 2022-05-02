{ lib
, fetchFromGitLab
, mkDerivation
, breeze-icons
, breeze-qt5
, cmake
, extra-cmake-modules
, ffmpeg-full
, kcodecs
, kconfig
, kcoreaddons
, kfilemetadata
, ki18n
, kiconthemes
, kio
, kio-extras
, kirigami2
, kxmlgui
, mpv
, pkg-config
, qqc2-desktop-style
, qtbase
, qtquickcontrols2
, qtwayland
, youtube-dl
}:

mkDerivation rec {
  pname = "haruna";
  version = "0.8.0";

  src = fetchFromGitLab {
    owner = "multimedia";
    repo = "haruna";
    rev = "v${version}";
    sha256 = "sha256-Lom9iQUKH3lQHrVK4dJzo+FG79xSCg0b4gY/KAevL6I=";
    domain = "invent.kde.org";
  };

  buildInputs = [
    breeze-icons
    breeze-qt5
    ffmpeg-full
    kcodecs
    kconfig
    kcoreaddons
    kfilemetadata
    ki18n
    kiconthemes
    kio
    kio-extras
    kirigami2
    kxmlgui
    mpv
    qqc2-desktop-style
    qtbase
    qtquickcontrols2
    qtwayland
    youtube-dl
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  meta = with lib; {
    homepage = "https://github.com/g-fb/haruna";
    description = "Open source video player built with Qt/QML and libmpv";
    license = with licenses; [ bsd3 cc-by-40 gpl3Plus wtfpl ];
    maintainers = with maintainers; [ jojosch ];
  };
}
