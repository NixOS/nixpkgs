{
  lib,
  mkDerivation,
  extra-cmake-modules,
  kdoctools,
  kauth,
  kcmutils,
  kconfigwidgets,
  kcoreaddons,
  kdbusaddons,
  kwallet,
  kxmlgui,
}:

mkDerivation {
  pname = "kwalletmanager";
  meta = {
    homepage = "https://apps.kde.org/kwalletmanager5/";

    description = "KDE wallet management tool";
    mainProgram = "kwalletmanager5";
    license = with lib.licenses; [ gpl2 ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kauth
    kcmutils
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    kwallet
    kxmlgui
  ];
}
