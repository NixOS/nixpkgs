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
    homepage = "https://apps.kde.org/dolphin/";
    description = "KDE file manager";
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
}
