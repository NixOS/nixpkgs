{ mkDerivation
, lib
, extra-cmake-modules
, qtquickcontrols2
, kcalendarcore
, kconfig
, kcoreaddons
, kdbusaddons
, kirigami2
, ki18n
, knotifications
}:

mkDerivation {
  pname = "kongress";

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [
    qtquickcontrols2
    kcalendarcore
    kconfig
    kcoreaddons
    kdbusaddons
    kirigami2
    ki18n
    knotifications
  ];

  meta = {
    description = "Companion application for conferences";
    homepage = "https://apps.kde.org/kongress/";
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
}
