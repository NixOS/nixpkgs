{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kcompletion, kconfig, kconfigwidgets, kcoreaddons, ki18n,
  kwidgetsaddons
}:

mkDerivation {
  pname = "libkmahjongg";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcompletion kconfig kconfigwidgets kcoreaddons ki18n
    kwidgetsaddons ];
  outputs = [ "out" "dev" ];
}
