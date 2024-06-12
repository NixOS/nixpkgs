{
  mkDerivation, lib,
  extra-cmake-modules,
  ki18n, kwidgetsaddons, kxmlgui
}:

mkDerivation {
  pname = "kcolorchooser";
  meta = {
    homepage = "https://apps.kde.org/kcolorchooser/";
    description = "Color chooser";
    mainProgram = "kcolorchooser";
    license = with lib.licenses; [ mit ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ki18n kwidgetsaddons kxmlgui ];
}
