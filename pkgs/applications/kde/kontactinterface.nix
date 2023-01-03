{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  kiconthemes, kparts, kwindowsystem, kxmlgui
}:

mkDerivation {
  pname = "kontactinterface";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kiconthemes kwindowsystem kxmlgui
  ];
  propagatedBuildInputs = [ kparts ];
}
