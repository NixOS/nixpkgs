{ mkDerivation
, lib
, extra-cmake-modules
, kdoctools
, kio
, kparts
, kxmlgui
, qtscript
, solid
, qtquickcontrols2
, kdeclarative
, kirigami2
, kquickcharts
}:

mkDerivation {
  pname = "filelight";
  meta = {
    description = "Disk usage statistics";
    homepage = "https://apps.kde.org/filelight/";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh vcunat ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kio
    kparts
    kxmlgui
    qtscript
    solid
    qtquickcontrols2
    kdeclarative
    kirigami2
    kquickcharts
  ];
  outputs = [ "out" "dev" ];
}
