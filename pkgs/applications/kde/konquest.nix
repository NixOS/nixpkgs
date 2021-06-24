{ lib
, mkDerivation
, extra-cmake-modules
, kdoctools
, kdelibs4support
, libkdegames
, qtquickcontrols
}:

mkDerivation {
  pname = "konquest";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kdelibs4support libkdegames qtquickcontrols ];
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ lheckemann ];
  };
}
