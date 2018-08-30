{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  ki18n, xcb-util-cursor,
  kconfig, kcoreaddons, kdbusaddons, kdeclarative, kio, kipi-plugins,
  knotifications, kscreen, kwidgetsaddons, kwindowsystem, kxmlgui, libkipi,
  qtx11extras, knewstuff
}:

mkDerivation {
  name = "spectacle";
  meta = with lib; { maintainers = with maintainers; [ ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kcoreaddons kdbusaddons kdeclarative ki18n kio knotifications
    kscreen kwidgetsaddons kwindowsystem kxmlgui libkipi qtx11extras xcb-util-cursor
    knewstuff
  ];
  propagatedUserEnvPkgs = [ kipi-plugins libkipi ];
}
