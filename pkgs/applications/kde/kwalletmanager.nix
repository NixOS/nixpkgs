{ lib
, mkDerivation
, extra-cmake-modules
, kdoctools
, wrapGAppsHook
, kauth
, kcmutils
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kdelibs4support
, kxmlgui
}:

mkDerivation {
  name = "kwalletmanager";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  propagatedBuildInputs = [
    kauth kcmutils kconfigwidgets kcoreaddons kdbusaddons kdelibs4support
    kxmlgui
  ];
}
