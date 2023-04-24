{ lib
, mkDerivation
, extra-cmake-modules
, shared-mime-info
, kconfig
, kdoctools
, kio
, ktextwidgets
, libkdegames
}:

mkDerivation {
  pname = "palapeli";
  nativeBuildInputs = [ extra-cmake-modules kdoctools shared-mime-info ];
  buildInputs = [ libkdegames kio ktextwidgets ];
  meta = {
    homepage = "https://apps.kde.org/palapeli/";
    description = "A single-player jigsaw puzzle game";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ harrisonthorne ];
  };
}
