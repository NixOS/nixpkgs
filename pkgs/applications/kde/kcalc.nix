{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  gmp,
  kconfig,
  kconfigwidgets,
  kcrash,
  kguiaddons,
  ki18n,
  kinit,
  knotifications,
  kxmlgui,
  mpfr,
}:

mkDerivation {
  pname = "kcalc";
  meta = {
    homepage = "https://apps.kde.org/kcalc/";
    description = "Scientific calculator";
    mainProgram = "kcalc";
    license = with lib.licenses; [ gpl2 ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    gmp
    kconfig
    kconfigwidgets
    kcrash
    kguiaddons
    ki18n
    kinit
    knotifications
    kxmlgui
    mpfr
  ];
}
