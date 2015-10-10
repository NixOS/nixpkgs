{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, kinit
, kcmutils
, kcoreaddons
, knewstuff
, ki18n
, kdbusaddons
, kbookmarks
, kconfig
, kio
, kparts
, solid
, kiconthemes
, kcompletion
, ktexteditor
, kwindowsystem
, knotifications
, kactivities
, phonon
, baloo
, baloo-widgets
, kfilemetadata
, kdelibs4support
}:

kdeApp {
  name = "dolphin";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kinit
    kcmutils
    kcoreaddons
    knewstuff
    kdbusaddons
    kbookmarks
    kconfig
    kparts
    solid
    kiconthemes
    kcompletion
    ktexteditor
    kwindowsystem
    knotifications
    phonon
    baloo-widgets
  ];
  propagatedBuildInputs = [
    baloo
    kactivities
    kdelibs4support
    kfilemetadata
    ki18n
    kio
  ];
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
