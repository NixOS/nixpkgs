{
  mkDerivation, lib,
  extra-cmake-modules, wrapGAppsHook,
  ki18n, kwidgetsaddons, kxmlgui
}:

mkDerivation {
  name = "kcolorchooser";
  meta = {
    license = with lib.licenses; [ mit ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules wrapGAppsHook ];
  buildInputs = [ ki18n ];
  propagatedBuildInputs = [ kwidgetsaddons kxmlgui ];
}
