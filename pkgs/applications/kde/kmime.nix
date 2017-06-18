{
  mkDerivation, lib,
  extra-cmake-modules, ki18n,
  kcodecs, qtbase,
}:

mkDerivation {
  name = "kmime";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ki18n ];
  buildInputs = [ kcodecs qtbase ];
}
