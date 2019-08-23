{ mkDerivation, lib
, extra-cmake-modules, kdoctools
, kconfig, kconfigwidgets, kcoreaddons, kdeclarative, ki18n
, kitemviews, kcmutils, kio, knewstuff, ktexteditor, kwidgetsaddons
, kwindowsystem, kxmlgui, qtscript, qtdeclarative, kqtquickcharts
, qtx11extras, qtgraphicaleffects, qtxmlpatterns, xorg
}:


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
      qtx11extras qtgraphicaleffects qtxmlpatterns
      xorg.libxkbfile xorg.libxcb
    ];

    enableParallelBuilding = true;
}
