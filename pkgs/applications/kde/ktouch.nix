{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kdeclarative,
  ki18n,
  kitemviews,
  kcmutils,
  kio,
  knewstuff,
  ktexteditor,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  qtscript,
  qtdeclarative,
  kqtquickcharts,
  qtx11extras,
  qtgraphicaleffects,
  qtxmlpatterns,
  qtquickcontrols2,
  xorg,
}:

mkDerivation {
  pname = "ktouch";
  meta = with lib; {
    homepage = "https://apps.kde.org/ktouch/";
    license = licenses.gpl2;
    maintainers = [ maintainers.schmittlauch ];
    description = "Touch typing tutor from the KDE software collection";
    mainProgram = "ktouch";
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    qtdeclarative
  ];
  buildInputs = [
    kconfig
    kconfigwidgets
    kcoreaddons
    kdeclarative
    ki18n
    kitemviews
    kcmutils
    kio
    knewstuff
    ktexteditor
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    qtscript
    qtdeclarative
    kqtquickcharts
    qtx11extras
    qtgraphicaleffects
    qtxmlpatterns
    qtquickcontrols2
    xorg.libxkbfile
    xorg.libxcb
  ];

  enableParallelBuilding = true;
}
