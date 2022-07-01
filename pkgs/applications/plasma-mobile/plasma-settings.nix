{ lib
, mkDerivation
, fetchFromGitLab

, cmake
, extra-cmake-modules

, kauth
, kconfig
, kcoreaddons
, kdbusaddons
, ki18n
, kitemmodels
, modemmanager-qt
, networkmanager-qt
, plasma-framework
}:

mkDerivation rec {
  pname = "plasma-settings";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kauth
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kitemmodels
    modemmanager-qt
    networkmanager-qt
    plasma-framework
  ];

  meta = with lib; {
    description = "Settings application for Plasma Mobile";
    homepage = "https://invent.kde.org/plasma-mobile/plasma-settings";
    # https://invent.kde.org/plasma-mobile/plasma-settings/-/commit/a59007f383308503e59498b3036e1483bca26e35
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}
