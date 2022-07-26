{ lib
, mkDerivation

, cmake
, extra-cmake-modules

, kcontacts
, ki18n
, kio
, kirigami2
, knotifications
, kpeople
, libphonenumber
, libqofono
, modemmanager-qt
, protobuf
, qcoro
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "spacebar";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kcontacts
    ki18n
    kio
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
    homepage = "https://invent.kde.org/plasma-mobile/spacebar";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}
