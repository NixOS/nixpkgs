{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  gmp, kconfig, kconfigwidgets, kcrash, kguiaddons, ki18n, kinit,
  knotifications, kxmlgui, mpfr,
}:

mkDerivation {
  pname = "kcalc";
  meta = {
    homepage = "https://apps.kde.org/kcalc/";
    description = "Scientific calculator";
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    gmp kconfig kconfigwidgets kcrash kguiaddons ki18n kinit knotifications
    kxmlgui mpfr
  ];
}
