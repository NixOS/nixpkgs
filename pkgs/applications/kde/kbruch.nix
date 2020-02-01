{ mkDerivation, lib, extra-cmake-modules, kdoctools
, kxmlgui, kconfig, kcrash, kwidgetsaddons }:

mkDerivation rec {
  name = "kbruch";

  buildInputs = [ kxmlgui kconfig kcrash kwidgetsaddons ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  meta = with lib; {
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ajs124 ];
  };
}
