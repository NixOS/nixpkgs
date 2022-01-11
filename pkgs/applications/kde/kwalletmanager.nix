{ lib
, mkDerivation
, extra-cmake-modules
, kdoctools
, kauth
, kcmutils
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kwallet
, kxmlgui
}:

mkDerivation {
  pname = "kwalletmanager";
  meta = {
    homepage = "https://apps.kde.org/kwalletmanager5/";

    description = "KDE wallet management tool";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kauth kcmutils kconfigwidgets kcoreaddons kdbusaddons
    kwallet kxmlgui
  ];
}
