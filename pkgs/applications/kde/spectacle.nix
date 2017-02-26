{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kconfig, kcoreaddons, kdbusaddons, kdeclarative, ki18n, kio, kipi-plugins,
  knotifications, kscreen, kwidgetsaddons, kwindowsystem, kxmlgui, libkipi,
  xcb-util-cursor
}:

let
  unwrapped =
    kdeApp {
      name = "spectacle";
      meta = with lib; { maintainers = with maintainers; [ ttuegel ]; };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        kconfig kcoreaddons kdbusaddons kdeclarative ki18n kio knotifications
        kscreen kwidgetsaddons kwindowsystem kxmlgui libkipi xcb-util-cursor
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/spectacle" ];
  paths = [ kipi-plugins ];
}
