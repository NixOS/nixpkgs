{
  lib,
  mkDerivation,

  cmake,
  extra-cmake-modules,

  kcalendarcore,
  kconfig,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  kirigami2,
  knotifications,
  kpeople,
  kservice,
  qtquickcontrols2,
}:

mkDerivation rec {
  pname = "calindori";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kcalendarcore
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kirigami2
    knotifications
    kpeople
    kservice
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Calendar for Plasma Mobile";
    homepage = "https://invent.kde.org/plasma-mobile/calindori";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}
