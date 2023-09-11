{ mkDerivation, lib
, extra-cmake-modules, kdoctools
, ki18n, xcb-util-cursor
, kconfig, kcoreaddons, kdbusaddons, kdeclarative, kio, kipi-plugins
, knotifications, kscreen, kwidgetsaddons, kwindowsystem, kxmlgui, libkipi
, qtx11extras, knewstuff, kwayland, qttools, kcolorpicker, kimageannotator
, qcoro, qtquickcontrols2, wayland, plasma-wayland-protocols, kpurpose, kpipewire
, wrapGAppsHook
}:

mkDerivation {
  pname = "spectacle";

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  buildInputs = [
    kconfig kcoreaddons kdbusaddons kdeclarative ki18n kio knotifications
    kscreen kwidgetsaddons kwindowsystem kxmlgui libkipi qtx11extras xcb-util-cursor
    knewstuff kwayland kcolorpicker kimageannotator qcoro qtquickcontrols2
    wayland plasma-wayland-protocols kpurpose kpipewire
  ];
  postPatch = ''
    substituteInPlace desktop/org.kde.spectacle.desktop.cmake \
      --replace "Exec=@QtBinariesDir@/qdbus" "Exec=${lib.getBin qttools}/bin/qdbus"
  '';

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  propagatedUserEnvPkgs = [ kipi-plugins libkipi ];
  meta = with lib; {
    homepage = "https://apps.kde.org/spectacle/";
    description = "Screenshot capture utility";
    maintainers = with maintainers; [ ttuegel ];
  };
}
