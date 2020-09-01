{ 
  lib
, mkDerivation
, extra-cmake-modules
, kdoctools
, kconfig, kio, ktextwidgets, kxmlgui
}:

mkDerivation {
  name = "kmag";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kdoctools kxmlgui kio ];
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ ];
  };
}
