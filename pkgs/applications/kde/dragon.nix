{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  baloo, baloo-widgets, kactivities, kbookmarks, kcmutils,
  kcompletion, kconfig, kcoreaddons, kdelibs4support, kdbusaddons,
  kfilemetadata, ki18n, kiconthemes, kinit, kio, knewstuff, knotifications,
  kparts, ktexteditor, kwindowsystem, phonon, solid, phonon-backend-gstreamer
}:

mkDerivation {
  name = "dragon";
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    description = "A simple media player for KDE";
    maintainers = [ lib.maintainers.jonathanreeve ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    baloo baloo-widgets kactivities kbookmarks kcmutils kcompletion kconfig
    kcoreaddons kdelibs4support kdbusaddons kfilemetadata ki18n kiconthemes
    kinit kio knewstuff knotifications kparts ktexteditor kwindowsystem
    phonon solid phonon-backend-gstreamer
  ];
  outputs = [ "out" "dev" ];
}
