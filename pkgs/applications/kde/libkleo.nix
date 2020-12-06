{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  boost, qgpgme, kcodecs, kcompletion, kconfig, kcoreaddons, ki18n, kitemmodels,
  kpimtextedit, kwidgetsaddons, kwindowsystem
}:

mkDerivation {
  name = "libkleo";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    boost kcodecs kcompletion kconfig kcoreaddons ki18n kitemmodels
    kpimtextedit kwidgetsaddons kwindowsystem
  ];
  propagatedBuildInputs = [ qgpgme ];
  outputs = [ "out" "dev" ];
}
