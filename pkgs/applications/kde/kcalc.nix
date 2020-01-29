{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  gmp, kconfig, kconfigwidgets, kcrash, kguiaddons, ki18n, kinit,
  knotifications, kxmlgui, mpfr,
}:

mkDerivation {
  name = "kcalc";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    gmp kconfig kconfigwidgets kcrash kguiaddons ki18n kinit knotifications
    kxmlgui mpfr
  ];
}
