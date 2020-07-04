{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  ki18n, xcb-util-cursor,
  kconfig, kcoreaddons, kdbusaddons, kdeclarative, kio, kipi-plugins,
  knotifications, kscreen, kwidgetsaddons, kwindowsystem, kxmlgui, libkipi,
  qtx11extras, knewstuff, kwayland, qttools
}:

mkDerivation {
  name = "spectacle";
  meta = with lib; { maintainers = with maintainers; [ ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kcoreaddons kdbusaddons kdeclarative ki18n kio knotifications
    kscreen kwidgetsaddons kwindowsystem kxmlgui libkipi qtx11extras xcb-util-cursor
    knewstuff kwayland
  ];
  postPatch = ''
    substituteInPlace desktop/org.kde.spectacle.desktop \
      --replace "Exec=qdbus" "Exec=${lib.getBin qttools}/bin/qdbus"
  '';
  propagatedUserEnvPkgs = [ kipi-plugins libkipi ];
}
