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
    ki18n
    kdbusaddons
    kbookmarks
    kconfig
    kio
    kparts
    solid
    kiconthemes
    kcompletion
    ktexteditor
    kwindowsystem
    knotifications
    kactivities
    phonon
    baloo-widgets
    kfilemetadata
    kdelibs4support
  ];
  propagatedBuildInputs = [
    baloo
  ];
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
