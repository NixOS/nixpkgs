{
  mkDerivation, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kparts, ktexteditor, kwidgetsaddons, libkomparediff2
}:

let
  unwrapped =
    mkDerivation {
      name = "kompare";
      meta = { license = with lib.licenses; [ gpl2 ]; };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        kparts ktexteditor kwidgetsaddons libkomparediff2
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kompare" ];
}
