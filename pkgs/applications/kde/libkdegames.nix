{ lib
, mkDerivation
, extra-cmake-modules
, kdoctools
, qtdeclarative
, kdeclarative
, kdnssd
, knewstuff
, openal
, libsndfile
, qtquickcontrols
}:

mkDerivation {
  pname = "libkdegames";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    qtdeclarative kdeclarative kdnssd knewstuff openal libsndfile
    qtquickcontrols
  ];
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ ];
  };
}
