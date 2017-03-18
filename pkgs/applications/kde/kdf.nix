{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kcmutils
}:

let
  unwrapped =
    kdeApp {
      name = "kdf";
      meta = {
        license = with lib.licenses; [ gpl2 ];
        maintainers = [ lib.maintainers.peterhoeg ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        kcmutils
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kdf" ];
}
