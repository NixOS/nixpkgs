{
  kdeApp, lib, kdeWrapper
  , extra-cmake-modules, kdoctools, kparts
  , qtsvg, qtxmlpatterns, ktexteditor, boost
}:

let
  unwrapped =
    kdeApp {
      name = "kig";
      meta = {
        license = with lib.licenses; [ gpl2 ];
        maintainers = with lib.maintainers; [ raskin ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      buildInputs = [
        kparts qtsvg qtxmlpatterns ktexteditor boost
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kig" ];
}


