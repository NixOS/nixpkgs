{ lib
, mkDerivation

, cmake
, extra-cmake-modules

, kcontacts
, ki18n
, kirigami2
, knotifications
, kpeople
, libphonenumber
, libqofono
, protobuf
, telepathy
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
    kirigami2
    knotifications
    kpeople
    libphonenumber
    libqofono
    protobuf # Needed by libphonenumber
    telepathy
  ];

  meta = with lib; {
    description = "SMS application for Plasma Mobile";
    homepage = "https://invent.kde.org/plasma-mobile/spacebar";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}
