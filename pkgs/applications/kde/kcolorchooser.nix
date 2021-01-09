{
  mkDerivation, lib,
  extra-cmake-modules,
  ki18n, kwidgetsaddons, kxmlgui
}:

mkDerivation {
  pname = "kcolorchooser";
  meta = {
    license = with lib.licenses; [ mit ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ki18n kwidgetsaddons kxmlgui ];
}
