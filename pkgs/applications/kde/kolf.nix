{ lib
, mkDerivation
, extra-cmake-modules
, kdoctools
, libkdegames, kconfig, kio, ktextwidgets
}:

mkDerivation {
  name = "kolf";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ libkdegames kio ktextwidgets ];
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
