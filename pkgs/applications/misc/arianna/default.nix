{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, pkg-config
, baloo
, kfilemetadata
, kirigami2
, kirigami-addons
, kquickcharts
, plasma-framework
, qqc2-desktop-style
, qtbase
, qtquickcontrols2
, qtwebsockets
, qtwebengine
}:

mkDerivation rec {
  pname = "arianna";
  version = "1.0.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = "arianna";
    rev = "v${version}";
    hash = "sha256-X3PDGWsQ8Alj5fisZC1tTHQDLPmjtiLw0X9gMvh5KFI=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    baloo
    kfilemetadata
    kirigami2
    kirigami-addons
    kquickcharts
    plasma-framework
    qqc2-desktop-style
    qtbase
    qtquickcontrols2
    qtwebsockets
    qtwebengine
  ];

  meta = with lib; {
    description = "An Epub Reader for Plasma and Plasma Mobile";
    homepage = "https://invent.kde.org/graphics/arianna";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Thra11 ];
  };
}
