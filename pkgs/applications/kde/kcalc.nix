{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  gmp, kconfig, kconfigwidgets, kguiaddons, ki18n, kinit, knotifications,
  kxmlgui,
}:

mkDerivation {
  name = "kcalc";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    gmp kconfig kconfigwidgets kguiaddons ki18n kinit knotifications kxmlgui
  ];
}
