{ lib
, mkDerivation
, kdeWrapper
, extra-cmake-modules
, kdoctools
, kdelibs4support
, libkexiv2
}:

let
  unwrapped =
    mkDerivation {
      name = "kolourpaint";
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        kdelibs4support
        libkexiv2
      ];

      meta = {
        maintainers = [ lib.maintainers.fridh ];
        license = with lib.licenses; [ gpl2 ];
      };
    };
in kdeWrapper {
  inherit unwrapped;
  targets = ["bin/kolourpaint"];
}
