{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, ki18n, kwidgetsaddons, kxmlgui
}:

let
  unwrapped =
    kdeApp {
      name = "kcolorchooser";
      meta = {
        license = with lib.licenses; [ mit ];
        maintainers = [ lib.maintainers.ttuegel ];
      };
      nativeBuildInputs = [ extra-cmake-modules ];
      propagatedBuildInputs = [ ki18n kwidgetsaddons kxmlgui ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kcolorchooser" ];
}
