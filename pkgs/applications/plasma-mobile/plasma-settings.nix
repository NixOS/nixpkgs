{
  lib,
  mkDerivation,

  cmake,
  extra-cmake-modules,

  kauth,
  kconfig,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  kirigami-addons,
  kirigami2,
  kitemmodels,
  libselinux,
  libsepol,
  modemmanager-qt,
  networkmanager-qt,
  pcre,
  plasma-framework,
  util-linux,
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
    kirigami-addons
    kirigami2
    kitemmodels
    libselinux
    libsepol
    modemmanager-qt
    networkmanager-qt
    pcre
    plasma-framework
    util-linux
  ];

  meta = with lib; {
    description = "Settings application for Plasma Mobile";
    mainProgram = "plasma-settings";
    homepage = "https://invent.kde.org/plasma-mobile/plasma-settings";
    # https://invent.kde.org/plasma-mobile/plasma-settings/-/commit/a59007f383308503e59498b3036e1483bca26e35
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
