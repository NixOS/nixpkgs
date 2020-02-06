{ lib
, mkDerivation
, extra-cmake-modules
, libGLU
, kdoctools
, kdeclarative
, libkdegames
}:

mkDerivation {
  name = "ksudoku";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ libGLU kdeclarative libkdegames ];
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ genesis ];
  };
}
