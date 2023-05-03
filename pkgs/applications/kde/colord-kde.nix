{ mkDerivation, lib
, extra-cmake-modules, ki18n
, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons, kiconthemes, kcmutils
, kio, knotifications, plasma-framework, kwidgetsaddons, kwindowsystem
, kitemmodels, kitemviews, lcms2, libXrandr, qtx11extras
}:

mkDerivation {
  pname = "colord-kde";

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [
    kconfig kconfigwidgets kcoreaddons kdbusaddons kiconthemes
    kcmutils ki18n kio knotifications plasma-framework kwidgetsaddons
    kwindowsystem kitemmodels kitemviews lcms2 libXrandr qtx11extras
  ];

  meta = with lib; {
    homepage = "https://projects.kde.org/projects/playground/graphics/colord-kde";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ttuegel ];
  };
}
