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
    kconfig
    kcrash
    kguiaddons
    kiconthemes
    kinit
    kjobwidgets
    kparts
    kxmlgui
    kdbusaddons
    kwallet
    kitemmodels
    knotifications
    threadweaver
    knewstuff
    libgit2
  ];
  propagatedBuildInputs = [
    kactivities
    ki18n
    kio
    ktexteditor
    kwindowsystem
    plasma-framework
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kate"
    wrapQtProgram "$out/bin/kwrite"
  '';
  meta = {
    license = with lib.licenses; [ gpl3 lgpl3 lgpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
