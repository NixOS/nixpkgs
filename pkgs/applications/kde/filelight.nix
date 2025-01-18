{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  kio,
  kparts,
  kxmlgui,
  qtscript,
  solid,
  qtquickcontrols2,
  kdeclarative,
  kirigami2,
  kquickcharts,
}:

mkDerivation {
  pname = "filelight";
  meta = with lib; {
    description = "Disk usage statistics";
    mainProgram = "filelight";
    homepage = "https://apps.kde.org/filelight/";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ vcunat ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
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
  outputs = [
    "out"
    "dev"
  ];
}
