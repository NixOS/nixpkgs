{ lib
, mkDerivation
, kdeWrapper
, extra-cmake-modules
, kdoctools
, kauth
, kcmutils
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kdelibs4support
, kxmlgui
}:

let
  unwrapped = mkDerivation {
    name = "kwalletmanager";
    meta = {
      license = with lib.licenses; [ gpl2 ];
      maintainers = with lib.maintainers; [ fridh ];
    };
    nativeBuildInputs = [ extra-cmake-modules kdoctools ];
    propagatedBuildInputs = [
      kauth
      kcmutils
      kconfigwidgets
      kcoreaddons
      kdbusaddons
      kdelibs4support
      kxmlgui
    ];
  };
in kdeWrapper {
  inherit unwrapped;
  targets = ["bin/kwalletmanager5"];
}
