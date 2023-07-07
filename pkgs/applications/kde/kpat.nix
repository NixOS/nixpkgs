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
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = with lib.maintainers; [ rnhmjoj ];
  };
}
