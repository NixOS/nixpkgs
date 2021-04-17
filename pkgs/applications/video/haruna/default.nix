{ lib
, fetchFromGitHub
, mkDerivation
, breeze-icons
, breeze-qt5
, cmake
, extra-cmake-modules
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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "g-fb";
    repo = "haruna";
    rev = version;
    sha256 = "sha256-8MauKmvQUwzq4Ssmm6g7/y6ADkye+eg/zyR3v/Wu848=";
  };

  buildInputs = [
    breeze-icons
    breeze-qt5
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
