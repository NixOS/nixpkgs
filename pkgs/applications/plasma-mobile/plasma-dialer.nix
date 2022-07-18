{ lib
, mkDerivation

, cmake
, extra-cmake-modules

, callaudiod
, kcontacts
, kcoreaddons
, kdbusaddons
, ki18n
, kirigami2
, knotifications
, kpeople
, libphonenumber
, modemmanager-qt
, protobuf
, qtfeedback
, qtmpris
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "plasma-dialer";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    callaudiod
    kcontacts
    kcoreaddons
    kdbusaddons
    ki18n
    kirigami2
    knotifications
    kpeople
    libphonenumber
    modemmanager-qt
    protobuf # Needed by libphonenumber
    qtfeedback
    qtmpris
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Dialer for Plasma Mobile";
    homepage = "https://invent.kde.org/plasma-mobile/plasma-dialer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}
