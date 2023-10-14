{ lib
, mkDerivation

, cmake
, extra-cmake-modules

, kconfig
, kcoreaddons
, kdbusaddons
, ki18n
, kirigami-addons
, kirigami2
, knotifications
, plasma-framework
, qtmultimedia
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "kclock";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kirigami-addons
    kirigami2
    knotifications
    plasma-framework
    qtmultimedia
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Clock app for plasma mobile";
    homepage = "https://invent.kde.org/plasma-mobile/kclock";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}
