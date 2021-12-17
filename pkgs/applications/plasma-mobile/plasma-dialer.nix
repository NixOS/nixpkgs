{ lib
, mkDerivation

, cmake
, extra-cmake-modules

, kcontacts
, kcoreaddons
, kdbusaddons
, ki18n
, kirigami2
, knotifications
, kpeople
, libphonenumber
, libpulseaudio
, libqofono
, protobuf
, pulseaudio-qt
, qtquickcontrols2
, telepathy
}:

mkDerivation rec {
  pname = "plasma-dialer";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kcontacts
    kcoreaddons
    kdbusaddons
    ki18n
    kirigami2
    knotifications
    kpeople
    libphonenumber
    libpulseaudio
    libqofono
    protobuf # Needed by libphonenumber
    pulseaudio-qt
    qtquickcontrols2
    telepathy
  ];

  meta = with lib; {
    description = "Dialer for Plasma Mobile";
    homepage = "https://invent.kde.org/plasma-mobile/plasma-dialer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}
