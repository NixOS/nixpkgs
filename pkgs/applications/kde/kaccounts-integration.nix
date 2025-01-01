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
  meta = with lib; {
    homepage = "https://community.kde.org/KTp/Setting_up_KAccounts";
    description = "Online accounts integration";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
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
