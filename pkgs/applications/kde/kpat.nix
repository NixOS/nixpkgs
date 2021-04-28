{ lib
, mkDerivation
, extra-cmake-modules
, knewstuff
, shared-mime-info
, libkdegames
, freecell-solver
, black-hole-solver
}:

mkDerivation {
  pname = "kpat";
  nativeBuildInputs = [
    extra-cmake-modules
    shared-mime-info
  ];
  buildInputs = [
    black-hole-solver
    knewstuff
    libkdegames
    freecell-solver
  ];
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = with lib.maintainers; [ rnhmjoj ];
  };
}
