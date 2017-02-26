{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kconfig, kconfigwidgets, kguiaddons, kinit, knotifications, gmp
}:

let
  unwrapped =
    kdeApp {
      name = "kcalc";
      meta = {
        license = with lib.licenses; [ gpl2 ];
        maintainers = [ lib.maintainers.fridh ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        gmp kconfig kconfigwidgets kguiaddons kinit knotifications
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kcalc" ];
}
