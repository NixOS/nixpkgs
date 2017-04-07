{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kiconthemes, kparts, kxmlgui
}:
kdeApp {
  name = "kontactinterface";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kiconthemes kxmlgui kparts
  ];
}
