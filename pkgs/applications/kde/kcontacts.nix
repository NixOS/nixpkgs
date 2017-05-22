{
  mkDerivation, lib,
  extra-cmake-modules,
  kcoreaddons, kconfig, kcodecs, ki18n, qtbase,
}:

mkDerivation {
  name = "kcontacts";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons kconfig kcodecs ki18n qtbase ];
}
