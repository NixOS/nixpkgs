{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kio, kparts, kxmlgui, qtbase, qtscript, solid
}:

mkDerivation {
  pname = "filelight";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh vcunat ];
    broken = lib.versionOlder qtbase.version "5.13";
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kio kparts kxmlgui qtscript solid
  ];
  outputs = [ "out" "dev" ];
}
