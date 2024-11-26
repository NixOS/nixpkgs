{ lib
, mkDerivation
, extra-cmake-modules
, kdoctools
, libkdegames, kio, ktextwidgets
}:

mkDerivation {
  pname = "kolf";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ libkdegames kio ktextwidgets ];
  meta = {
    homepage = "https://apps.kde.org/kolf/";
    description = "Miniature golf";
    mainProgram = "kolf";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
