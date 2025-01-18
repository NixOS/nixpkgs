{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  dolphin,
  ki18n,
  kio,
  kxmlgui,
}:

mkDerivation {
  pname = "dolphin-plugins";
  meta = with lib; {
    license = [ licenses.gpl2 ];
    maintainers = [ maintainers.ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  propagatedBuildInputs = [
    dolphin
    ki18n
    kio
    kxmlgui
  ];
  outputs = [
    "out"
    "dev"
  ];
}
