{ lib
, mkDerivation

, cmake
, extra-cmake-modules

, kconfig
, ki18n
, kirigami2
, knotifications
, kquickcharts
, kweathercore
, plasma-framework
, qtcharts
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "kweather";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    ki18n
    kirigami2
    knotifications
    kquickcharts
    kweathercore
    plasma-framework
    qtcharts
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Weather application for Plasma Mobile";
    homepage = "https://invent.kde.org/plasma-mobile/kweather";
    license = with licenses; [ gpl2Plus cc-by-40 ];
    maintainers = with maintainers; [ samueldr ];
  };
}
