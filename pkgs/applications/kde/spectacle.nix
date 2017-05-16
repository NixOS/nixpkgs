{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kconfig, kcoreaddons, kdbusaddons, kdeclarative, ki18n, kio, kipi-plugins,
  knotifications, kscreen, kwidgetsaddons, kwindowsystem, kxmlgui, libkipi,
  xcb-util-cursor
}:

mkDerivation {
  name = "spectacle";
  meta = with lib; { maintainers = with maintainers; [ ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kdbusaddons kdeclarative ki18n kio knotifications
    kscreen kwidgetsaddons kwindowsystem kxmlgui libkipi xcb-util-cursor
  ];
  propagatedUserEnvPkgs = [ kipi-plugins ];
}
