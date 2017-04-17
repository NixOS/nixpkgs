{
  kdeApp, lib,
  extra-cmake-modules, kdoctools,
  boost, gpgme, kcodecs, kcompletion, kconfig, kcoreaddons, kitemmodels,
  kwidgetsaddons, kwindowsystem
}:
kdeApp {
  name = "libkleo";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    boost gpgme kcodecs kcompletion kconfig kcoreaddons kitemmodels
    kwidgetsaddons kwindowsystem
  ];
}
