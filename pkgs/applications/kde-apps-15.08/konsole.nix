{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, qtscript
, kbookmarks
, kcompletion
, kconfig
, kconfigwidgets
, kcoreaddons
, kguiaddons
, ki18n
, kiconthemes
, kinit
, kdelibs4support
, kio
, knotifications
, knotifyconfig
, kparts
, kpty
, kservice
, ktextwidgets
, kwidgetsaddons
, kwindowsystem
, kxmlgui
}:

kdeApp {
  name = "konsole";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  buildInputs = [
    qtscript
    kbookmarks
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kguiaddons
    kiconthemes
    kinit
    kio
    knotifications
    knotifyconfig
    kparts
    kpty
    kservice
    ktextwidgets
    kwidgetsaddons
    kxmlgui
  ];
  propagatedBuildInputs = [
    kdelibs4support
    ki18n
    kwindowsystem
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/konsole"
  '';
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
