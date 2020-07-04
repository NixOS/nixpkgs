{ lib
, mkDerivation
, extra-cmake-modules
, kdoctools
, kdeclarative
, knewstuff
, libkdegames
, libkmahjongg
}:

mkDerivation {
  name = "kmahjongg";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kdeclarative libkmahjongg knewstuff libkdegames ];
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ genesis ];
  };
}
