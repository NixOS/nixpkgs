{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  ki18n, xcb-util-cursor,
  kconfig, kcoreaddons, kdbusaddons, kdeclarative, kio, kipi-plugins,
  knotifications, kscreen, kwidgetsaddons, kwindowsystem, kxmlgui, libkipi,
  qtx11extras, knewstuff, kwayland, qttools,
  patchDesktopFileExecHook
}:

mkDerivation {
  name = "spectacle";
  meta = with lib; { maintainers = with maintainers; [ ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools patchDesktopFileExecHook ];
  buildInputs = [
    kconfig kcoreaddons kdbusaddons kdeclarative ki18n kio knotifications
    kscreen kwidgetsaddons kwindowsystem kxmlgui libkipi qtx11extras xcb-util-cursor
    knewstuff qttools kwayland
  ];
  propagatedUserEnvPkgs = [ kipi-plugins libkipi ];
}
