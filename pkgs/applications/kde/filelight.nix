{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kio, kparts, kxmlgui, qtscript, solid
}:

mkDerivation {
  pname = "filelight";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh vcunat ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kio kparts kxmlgui qtscript solid
  ];
  outputs = [ "out" "dev" ];
}
