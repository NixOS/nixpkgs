{ lib
, mkDerivation
, extra-cmake-modules
, knewstuff
, shared-mime-info
, libkdegames
, freecell-solver
}:

mkDerivation {
  name = "kpat";
  nativeBuildInputs = [
    extra-cmake-modules
    shared-mime-info
  ];
  buildInputs = [
    knewstuff
    libkdegames
    freecell-solver
  ];
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = with lib.maintainers; [ rnhmjoj ];
  };
}
