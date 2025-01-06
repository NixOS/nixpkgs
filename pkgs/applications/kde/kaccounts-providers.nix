{
  mkDerivation,
  lib,
  accounts-qt,
  extra-cmake-modules,
  intltool,
  kaccounts-integration,
  kcmutils,
  kcoreaddons,
  kdeclarative,
  kdoctools,
  kio,
  kpackage,
  kwallet,
  qtwebengine,
  signond,
}:

mkDerivation {
  pname = "kaccounts-providers";
  meta = {
    homepage = "https://community.kde.org/KTp/Setting_up_KAccounts";
    description = "Online account providers";
    maintainers = with lib.maintainers; [ kennyballou ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
    intltool
    kdoctools
  ];
  buildInputs = [
    accounts-qt
    kaccounts-integration
    kcmutils
    kcoreaddons
    kdeclarative
    kio
    kpackage
    kwallet
    qtwebengine
    signond
  ];
}
