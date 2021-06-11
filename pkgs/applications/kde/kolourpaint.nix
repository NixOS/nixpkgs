{ lib
, mkDerivation
, extra-cmake-modules
, kdoctools
, kguiaddons
, kio
, ktextwidgets
, kwidgetsaddons
, kxmlgui
, libkexiv2
}:

mkDerivation {
  pname = "kolourpaint";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kguiaddons kio ktextwidgets kwidgetsaddons kxmlgui libkexiv2
  ];
  meta = {
    maintainers = [ lib.maintainers.fridh ];
    license = with lib.licenses; [ gpl2 ];
  };
}
