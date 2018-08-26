{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  baloo, baloo-widgets, kactivities, kbookmarks, kcmutils,
  kcompletion, kconfig, kcoreaddons, kdelibs4support, kdbusaddons,
  kfilemetadata, ki18n, kiconthemes, kinit, kio, knewstuff, knotifications,
  kparts, ktexteditor, kwindowsystem, phonon, solid
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
  # We need the RPATH for linking, because the `libkdeinit5_dolphin.so` links
  # private against its dependencies and without the correct RPATH, these
  # dependencies are not found.
  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=OFF" ];
}
