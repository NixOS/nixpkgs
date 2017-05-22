{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  ki18n, xcb-util-cursor,
  kconfig, kcoreaddons, kdbusaddons, kdeclarative, kio, kipi-plugins,
  knotifications, kscreen, kwidgetsaddons, kwindowsystem, kxmlgui, libkipi,
  qtx11extras
}:

mkDerivation {
  name = "spectacle";
  meta = with lib; { maintainers = with maintainers; [ ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ ki18n xcb-util-cursor ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kdbusaddons kdeclarative kio knotifications
    kscreen kwidgetsaddons kwindowsystem kxmlgui libkipi qtx11extras
  ];
  propagatedUserEnvPkgs = [ kipi-plugins ];
}
