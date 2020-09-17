{ mkDerivation, lib, extra-cmake-modules, kdoctools, intltool, kaccounts-integration, kcoreaddons, accounts-qt, signond, qtwebengine, kio, kdeclarative, kpackage }:

mkDerivation {
  name = "kaccounts-providers";
  meta = with lib; {
    homepage = "https://community.kde.org/KTp/Setting_up_KAccounts";
    description = "Online accounts providers";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
    intltool
  ];
  buildInputs = [
    kdoctools
    kaccounts-integration
    kcoreaddons
    kdeclarative
    kpackage
    accounts-qt
    signond
    qtwebengine
    kio
  ];
}
