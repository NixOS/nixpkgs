{
  lib,
  mkDerivation,

  cmake,
  extra-cmake-modules,
  wrapQtAppsHook,

  c-ares,
  curl,
  kcontacts,
  ki18n,
  kio,
  kirigami-addons,
  kirigami2,
  knotifications,
  kpeople,
  libphonenumber,
  modemmanager-qt,
  protobuf,
  qcoro,
  qtquickcontrols2,
}:

mkDerivation {
  pname = "spacebar";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    c-ares
    curl
    kcontacts
    ki18n
    kio
    kirigami-addons
    kirigami2
    knotifications
    kpeople
    libphonenumber
    modemmanager-qt
    protobuf # Needed by libphonenumber
    qcoro
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "SMS application for Plasma Mobile";
    mainProgram = "spacebar";
    homepage = "https://invent.kde.org/plasma-mobile/spacebar";
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
