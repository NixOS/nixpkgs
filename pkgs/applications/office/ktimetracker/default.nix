{
  mkDerivation,
  lib,
  fetchurl,
  cmake,
  pkg-config,
  extra-cmake-modules,
  kconfig,
  kconfigwidgets,
  kdbusaddons,
  kdoctools,
  ki18n,
  kidletime,
  kjobwidgets,
  kio,
  knotifications,
  kwindowsystem,
  kxmlgui,
  ktextwidgets,
  kcalendarcore,
}:

mkDerivation rec {
  pname = "ktimetracker";
  version = "5.0.1";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${pname}-${version}.tar.xz";
    sha256 = "0jp63fby052rapjjaz413b1wjz4qsgpxh82y2d75jzimch0n5s02";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kconfigwidgets
    kdbusaddons
    kdoctools
    ki18n
    kidletime
    kjobwidgets
    kio
    knotifications
    kwindowsystem
    kxmlgui
    ktextwidgets
    kcalendarcore
  ];

  meta = with lib; {
    description = "Todo management and time tracking application";
    mainProgram = "ktimetracker";
    license = licenses.gpl2;
    homepage = "https://userbase.kde.org/KTimeTracker";
    maintainers = with maintainers; [ dtzWill ];
  };
}
