{ lib
, mkDerivation
, gcc12Stdenv
, srcs

, cmake
, extra-cmake-modules
, wrapQtAppsHook

, c-ares
, curl
, kcontacts
, ki18n
, kio
, kirigami-addons
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

# Workaround for AArch64 still using GCC9.
gcc12Stdenv.mkDerivation rec {
  pname = "spacebar";
  inherit (srcs.spacebar) version src;

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
    homepage = "https://invent.kde.org/plasma-mobile/spacebar";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}
