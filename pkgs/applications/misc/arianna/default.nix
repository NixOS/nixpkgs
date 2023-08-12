{ lib
, mkDerivation
, fetchurl
, cmake
, extra-cmake-modules
, pkg-config
, baloo
, kfilemetadata
, kirigami2
, kirigami-addons
, kitemmodels
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
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://kde/stable/arianna/arianna-${version}.tar.xz";
    hash = "sha256-C60PujiUTyw2DwImu8PVmU687CP9CuWZ+d8LuZKthKY=";
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
    kitemmodels
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
