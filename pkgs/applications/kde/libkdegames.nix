{ lib
, mkDerivation
, extra-cmake-modules
, kdoctools
, kdelibs4support
, qtdeclarative
, kdeclarative
, kdnssd
, knewstuff
, openal
, libsndfile
, qtquickcontrols
}:

mkDerivation {
  name = "libkdegames";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kdelibs4support qtdeclarative kdeclarative kdnssd knewstuff openal libsndfile
    qtquickcontrols
  ];
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ lheckemann ];
  };
}
