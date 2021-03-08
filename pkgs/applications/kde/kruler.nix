{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  knotifications, kwindowsystem, kxmlgui, qtx11extras
}:

mkDerivation {
  pname = "kruler";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kwindowsystem knotifications kxmlgui qtx11extras
  ];
}
