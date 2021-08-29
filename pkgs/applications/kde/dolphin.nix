{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  baloo, baloo-widgets, kactivities, kbookmarks, kcmutils,
  kcompletion, kconfig, kcoreaddons, kdbusaddons,
  kfilemetadata, ki18n, kiconthemes, kinit, kio, knewstuff, knotifications,
  kparts, ktexteditor, kwindowsystem, phonon, solid,
  wayland, qtbase, qtwayland
}:

mkDerivation {
  pname = "dolphin";
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
    broken = lib.versionOlder qtbase.version "5.14";
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedUserEnvPkgs = [ baloo ];
  propagatedBuildInputs = [
    baloo baloo-widgets kactivities kbookmarks kcmutils kcompletion kconfig
    kcoreaddons kdbusaddons kfilemetadata ki18n kiconthemes
    kinit kio knewstuff knotifications kparts ktexteditor kwindowsystem
    phonon solid
    wayland qtwayland
  ];
  outputs = [ "out" "dev" ];
  # We need the RPATH for linking, because the `libkdeinit5_dolphin.so` links
  # private against its dependencies and without the correct RPATH, these
  # dependencies are not found.
  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=OFF" ];
}
