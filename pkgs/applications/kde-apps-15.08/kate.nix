{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, qtscript
, kactivities
, kconfig
, kcrash
, kguiaddons
, kiconthemes
, ki18n
, kinit
, kjobwidgets
, kio
, kparts
, ktexteditor
, kwindowsystem
, kxmlgui
, kdbusaddons
, kwallet
, plasma-framework
, kitemmodels
, knotifications
, threadweaver
, knewstuff
, libgit2
}:

kdeApp {
  name = "kate";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    qtscript
    kactivities
    kconfig
    kcrash
    kguiaddons
    kiconthemes
    ki18n
    kinit
    kjobwidgets
    kio
    kparts
    ktexteditor
    kwindowsystem
    kxmlgui
    kdbusaddons
    kwallet
    plasma-framework
    kitemmodels
    knotifications
    threadweaver
    knewstuff
    libgit2
  ];
  meta = {
    license = with lib.licenses; [ gpl3 lgpl3 lgpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
