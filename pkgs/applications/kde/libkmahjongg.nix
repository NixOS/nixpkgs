{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  kcompletion, kconfig, kconfigwidgets, kcoreaddons, ki18n,
  kwidgetsaddons
}:

mkDerivation {
  name = "libkmahjongg";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ genesis ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcompletion kconfig kconfigwidgets kcoreaddons ki18n
    kwidgetsaddons ];
  outputs = [ "out" "dev" ];
}
