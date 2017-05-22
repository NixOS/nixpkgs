{ lib
, mkDerivation
, extra-cmake-modules
, kdoctools
, kauth
, kcmutils
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kdelibs4support
, kwallet
, kxmlgui
}:

mkDerivation {
  name = "kwalletmanager";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kauth kcmutils kconfigwidgets kcoreaddons kdbusaddons kdelibs4support
    kwallet kxmlgui
  ];
}
