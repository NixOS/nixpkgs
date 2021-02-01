{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kcoreaddons, kdeclarative, ki18n, kio, kwidgetsaddons, samba, qtbase,
}:

mkDerivation {
  pname = "kdenetwork-filesharing";
  meta = {
    license = [ lib.licenses.gpl2 lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
    broken = lib.versionOlder qtbase.version "5.13";
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcoreaddons kdeclarative ki18n kio kwidgetsaddons samba ];
}
