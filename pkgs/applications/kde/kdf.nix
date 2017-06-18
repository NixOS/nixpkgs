{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kcmutils
}:

mkDerivation {
  name = "kdf";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.peterhoeg ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ kcmutils ];
}
