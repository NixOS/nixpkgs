{
  mkDerivation, lib,
  extra-cmake-modules, ki18n,
  kcoreaddons, kconfig, kcodecs
}:

mkDerivation {
  name = "kcontacts";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ki18n ];
  propagatedBuildInputs = [ kcoreaddons kconfig kcodecs ];
}
