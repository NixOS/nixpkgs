{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kconfig, kconfigwidgets, kcoreaddons, kdeclarative, ki18n,
  kitemviews, kcmutils, kio, knewstuff, ktexteditor, kwidgetsaddons,
  kwindowsystem, kxmlgui, qtscript, qtdeclarative, kqtquickcharts,
  withX11 ? true, xorg, qtx11extras}:


  mkDerivation {
    name = "ktouch";
    meta = {
      license = lib.licenses.gpl2;
      maintainers = [ lib.maintainers.schmittlauch ];
      description = "A touch typing tutor from the KDE software collection";
    };
    nativeBuildInputs = [ extra-cmake-modules kdoctools qtdeclarative ];
    buildInputs = [
      kconfig kconfigwidgets kcoreaddons kdeclarative ki18n
      kitemviews kcmutils kio knewstuff ktexteditor kwidgetsaddons
      kwindowsystem kxmlgui qtscript qtdeclarative kqtquickcharts
    ]
    ++ lib.optionals withX11 (with xorg; [ libxcb libxkbfile qtx11extras ]);
  #propagatedUserEnvPkgs = [ kipi-plugins libkipi (lib.getBin kinit) ];
  enableParallelBuilding = true;
}
