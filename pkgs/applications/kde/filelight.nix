{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kio, kparts, kxmlgui, qtbase, qtscript, solid, qtquickcontrols2, kdeclarative
}:

mkDerivation {
  pname = "filelight";
  meta = {
    description = "Disk usage statistics";
    homepage = "https://apps.kde.org/filelight/";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh vcunat ];
    broken = lib.versionOlder qtbase.version "5.13";
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kio kparts kxmlgui qtscript solid qtquickcontrols2 kdeclarative
  ];
  outputs = [ "out" "dev" ];
}
