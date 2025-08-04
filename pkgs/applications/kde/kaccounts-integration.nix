{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  kcmutils,
  kcoreaddons,
  kwallet,
  accounts-qt,
  signond,
  qcoro,
}:

mkDerivation {
  pname = "kaccounts-integration";
  meta = {
    homepage = "https://community.kde.org/KTp/Setting_up_KAccounts";
    description = "Online accounts integration";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kcmutils
    kcoreaddons
    kdoctools
    kwallet
    accounts-qt
    signond
    qcoro
  ];
}
