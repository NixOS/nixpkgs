{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, shared-mime-info, qtbase, accounts-qt,
  boost, kaccounts-integration, kcompletion, kconfigwidgets, kcrash, kdbusaddons,
  kdesignerplugin, ki18n, kiconthemes, kio, kitemmodels, kwindowsystem, mysql, qttools,
  signond,
}:

mkDerivation {
  pname = "akonadi";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = kdepimTeam;
    broken = lib.versionOlder qtbase.version "5.13";
  };
  patches = [
    ./0001-akonadi-paths.patch
    ./0002-akonadi-timestamps.patch
    ./0003-akonadi-revert-make-relocatable.patch
  ];
  nativeBuildInputs = [ extra-cmake-modules shared-mime-info ];
  buildInputs = [
    kaccounts-integration kcompletion kconfigwidgets kcrash kdbusaddons kdesignerplugin
    ki18n kiconthemes kio kwindowsystem accounts-qt qttools signond
  ];
  propagatedBuildInputs = [ boost kitemmodels ];
  outputs = [ "out" "dev" ];
  CXXFLAGS = [
    ''-DNIXPKGS_MYSQL_MYSQLD=\"${lib.getBin mysql}/bin/mysqld\"''
    ''-DNIXPKGS_MYSQL_MYSQLADMIN=\"${lib.getBin mysql}/bin/mysqladmin\"''
    ''-DNIXPKGS_MYSQL_MYSQL_INSTALL_DB=\"${lib.getBin mysql}/bin/mysql_install_db\"''
    ''-DNIXPKGS_MYSQL_MYSQLCHECK=\"${lib.getBin mysql}/bin/mysqlcheck\"''
    ''-DNIXPKGS_POSTGRES_PG_CTL=\"\"''
    ''-DNIXPKGS_POSTGRES_PG_UPGRADE=\"\"''
    ''-DNIXPKGS_POSTGRES_INITDB=\"\"''
  ];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIX_OUT=\"$out\""
  '';
}
