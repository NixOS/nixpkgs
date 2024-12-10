{
  lib,
  mkDerivation,

  cmake,
  extra-cmake-modules,

  kconfig,
  kholidays,
  ki18n,
  kirigami-addons,
  kirigami2,
  knotifications,
  kquickcharts,
  kweathercore,
  plasma-framework,
  qtcharts,
  qtquickcontrols2,
}:

mkDerivation rec {
  pname = "kweather";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kholidays
    ki18n
    kirigami-addons
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
    mainProgram = "kweather";
    homepage = "https://invent.kde.org/plasma-mobile/kweather";
    license = with licenses; [
      gpl2Plus
      cc-by-40
    ];
    maintainers = with maintainers; [ samueldr ];
  };
}
