{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kconfig, kconfigwidgets, kguiaddons, kinit, knotifications, gmp
}:

mkDerivation {
  name = "kcalc";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  buildInputs = [ gmp ];
  propagatedBuildInputs = [
    kconfig kconfigwidgets kguiaddons kinit knotifications
  ];
}
