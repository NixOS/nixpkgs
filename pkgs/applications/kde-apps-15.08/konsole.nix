{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
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
  ];
  buildInputs = [
    qtscript
    kbookmarks
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kguiaddons
    ki18n
    kiconthemes
    kinit
    kdelibs4support
    kio
    knotifications
    knotifyconfig
    kparts
    kpty
    kservice
    ktextwidgets
    kwidgetsaddons
    kwindowsystem
    kxmlgui
  ];
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
