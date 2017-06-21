{ mkDerivation, lib, extra-cmake-modules, libraw, qtbase }:

mkDerivation {
  name = "libkdcraw";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
  propagatedBuildInputs = [ libraw ];
}
