{
  mkDerivation, lib, kdoctools, extra-cmake-modules,
  karchive, kcrash, kdbusaddons, ki18n, kiconthemes, knewstuff, knotifications,
  knotifyconfig, konsole, kparts, kwindowsystem, qtx11extras
}:

mkDerivation {
  name = "yakuake";

  buildInputs = [
    karchive kcrash kdbusaddons ki18n kiconthemes knewstuff knotifications
    knotifyconfig kparts kwindowsystem qtx11extras
  ];

  propagatedBuildInputs = [
    karchive kcrash kdbusaddons ki18n kiconthemes knewstuff knotifications
    knotifyconfig kparts kwindowsystem
  ];

  propagatedUserEnvPkgs = [ konsole ];

  nativeBuildInputs = [
    extra-cmake-modules kdoctools
  ];

  meta = {
    homepage = https://yakuake.kde.org;
    description = "Quad-style terminal emulator for KDE";
    maintainers = with lib.maintainers; [ fridh ];
    license = lib.licenses.gpl2;
  };
}
