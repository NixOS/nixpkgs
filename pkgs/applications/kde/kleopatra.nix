{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  boost, gpgme, kcmutils, kdbusaddons, kiconthemes, kitemmodels, kmime,
  knotifications, kwindowsystem, kxmlgui, libkleo, kcrash
}:

mkDerivation {
  name = "kleopatra";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    boost gpgme kcmutils kdbusaddons kiconthemes kitemmodels kmime
    knotifications kwindowsystem kxmlgui libkleo kcrash
  ];
}
