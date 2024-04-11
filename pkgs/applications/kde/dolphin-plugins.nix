{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  dolphin, ki18n, kio, kxmlgui
}:

mkDerivation {
  pname = "dolphin-plugins";
  meta = {
    license = [ lib.licenses.gpl2Only ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    dolphin ki18n kio kxmlgui
  ];
  outputs = [ "out" "dev" ];
}
