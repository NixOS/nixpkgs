{ mkDerivation, lib, extra-cmake-modules, kdoctools
, kcrash, kguiaddons, ki18n, kparts, kwidgetsaddons, kdbusaddons
}:

mkDerivation {
  name = "kmplot";
  meta = {
    license = with lib.licenses; [ gpl2Plus fdl12 ];
    maintainers = [ lib.maintainers.orivej ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcrash kguiaddons ki18n kparts kwidgetsaddons kdbusaddons
  ];
}
