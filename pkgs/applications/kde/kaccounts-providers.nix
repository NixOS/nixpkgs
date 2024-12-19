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
  meta = with lib; {
    homepage = "https://community.kde.org/KTp/Setting_up_KAccounts";
    description = "Online account providers";
    maintainers = with maintainers; [ kennyballou ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
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
