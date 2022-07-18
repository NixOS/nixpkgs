{
  mkDerivation, lib, kdoctools, extra-cmake-modules,
  karchive, kcrash, kdbusaddons, ki18n, kiconthemes, knewstuff, knotifications,
  knotifyconfig, konsole, kparts, kwayland, kwindowsystem, qtx11extras
}:

mkDerivation {
  pname = "yakuake";

  buildInputs = [
    karchive kcrash kdbusaddons ki18n kiconthemes knewstuff knotifications
    knotifyconfig kparts kwayland kwindowsystem qtx11extras
  ];

  propagatedBuildInputs = [
    karchive kcrash kdbusaddons ki18n kiconthemes knewstuff knotifications
    knotifyconfig kparts kwindowsystem
  ];

  propagatedUserEnvPkgs = [ konsole ];

  nativeBuildInputs = [
    extra-cmake-modules kdoctools
  ];

  outputs = [ "out" "dev" ];

  meta = {
    homepage = "https://yakuake.kde.org";
    description = "Quad-style terminal emulator for KDE";
    maintainers = with lib.maintainers; [ fridh ];
    license = lib.licenses.gpl2;
  };
}
