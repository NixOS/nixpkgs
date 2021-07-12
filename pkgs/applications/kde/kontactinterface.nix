{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  kiconthemes, kparts, kwindowsystem, kxmlgui
}:

mkDerivation {
  pname = "kontactinterface";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kiconthemes kwindowsystem kxmlgui
  ];
  propagatedBuildInputs = [ kparts ];
}
