{
  mkDerivation,
  lib,
  extra-cmake-modules,
  ki18n,
  kwidgetsaddons,
  kxmlgui,
}:

mkDerivation {
  pname = "kcolorchooser";
  meta = with lib; {
    homepage = "https://apps.kde.org/kcolorchooser/";
    description = "Color chooser";
    mainProgram = "kcolorchooser";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    ki18n
    kwidgetsaddons
    kxmlgui
  ];
}
