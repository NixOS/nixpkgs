{ mkDerivation, lib
, extra-cmake-modules, kdoctools
, ki18n, xcb-util-cursor
, kconfig, kcoreaddons, kdbusaddons, kdeclarative, kio, kipi-plugins
, knotifications, kscreen, kwidgetsaddons, kwindowsystem, kxmlgui, libkipi
, qtx11extras, knewstuff, kwayland, qttools, kcolorpicker, kimageannotator
, qcoro, qtquickcontrols2, wayland, plasma-wayland-protocols, kpurpose, kpipewire
, wrapGAppsHook, fetchpatch
}:

mkDerivation {
  pname = "spectacle";

  patches = [
    # backport fix for region capture with multi-display high-dpi setups
    # FIXME: remove in 23.08
    (fetchpatch {
      url = "https://invent.kde.org/graphics/spectacle/-/commit/d0886c85445fad227b256152a549cb33bd97b776.patch";
      hash = "sha256-t0+X1pzjlS2OWduMwQBoYbjh+o/SF4hOkAqzz/MJw3E=";
    })
  ];

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
