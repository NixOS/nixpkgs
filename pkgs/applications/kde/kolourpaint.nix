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
    homepage = "https://apps.kde.org/kolourpaint/";
    description = "Paint program";
    mainProgram = "kolourpaint";
    license = with lib.licenses; [ gpl2 ];
  };
}
