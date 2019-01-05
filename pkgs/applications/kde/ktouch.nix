{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kconfig, kconfigwidgets, kcoreaddons, kdeclarative, ki18n,
  kitemviews, kcmutils, kio, knewstuff, ktexteditor, kwidgetsaddons,
  kwindowsystem, kxmlgui, qtscript, qtdeclarative, kqtquickcharts, qtx11extras,
  withX11 ? true, xorg }:


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
      kwindowsystem kxmlgui qtscript qtdeclarative kqtquickcharts qtx11extras 
      xorg.libxkbfile
    ]
    # According to Readme.md, libxkbfile is supposed to be optional as well.
    # But as CMake currently fails without that lib, we still always include it.
    ++ lib.optionals withX11 (with xorg; [ libxcb ]);
}
