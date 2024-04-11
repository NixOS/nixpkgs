{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kcoreaddons, kdeclarative, ki18n, kio, kwidgetsaddons, samba, qcoro
}:

mkDerivation {
  pname = "kdenetwork-filesharing";
  meta = {
    license = [ lib.licenses.gpl2Only lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcoreaddons kdeclarative ki18n kio kwidgetsaddons samba qcoro ];
}
