{ lib
, mkDerivation
, extra-cmake-modules, kdoctools
, kdelibs4support, kcmutils, khtml, kdesu
, qtwebkit, qtwebengine, qtx11extras, qtscript, qtwayland
}:

mkDerivation {
  name = "konqueror";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kdelibs4support kcmutils khtml kdesu
    qtwebkit qtwebengine qtx11extras qtscript qtwayland
  ];
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ ];
  };
}

