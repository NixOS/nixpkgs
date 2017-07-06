{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  baloo, baloo-widgets, dolphin-plugins, kactivities, kbookmarks, kcmutils,
  kcompletion, kconfig, kcoreaddons, kdelibs4support, kdbusaddons,
  kfilemetadata, ki18n, kiconthemes, kinit, kio, knewstuff, knotifications,
  konsole, kparts, ktexteditor, kwindowsystem, phonon, solid
}:

mkDerivation {
  name = "dolphin";
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    baloo baloo-widgets kactivities kbookmarks kcmutils kcompletion kconfig
    kcoreaddons kdelibs4support kdbusaddons kfilemetadata ki18n kiconthemes
    kinit kio knewstuff knotifications kparts ktexteditor kwindowsystem
    phonon solid
  ];
  outputs = [ "out" "dev" ];
}
