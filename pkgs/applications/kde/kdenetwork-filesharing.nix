{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kcoreaddons, ki18n, kio, kwidgetsaddons, samba
}:

mkDerivation {
  name = "kdenetwork-filesharing";
  meta = {
    license = [ lib.licenses.gpl2 lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ kcoreaddons ki18n kio kwidgetsaddons samba ];
}
