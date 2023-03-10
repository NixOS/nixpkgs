{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, shared-mime-info, qtbase, accounts-qt,
  boost, kaccounts-integration, kcompletion, kconfigwidgets, kcrash, kdbusaddons,
  kdesignerplugin, ki18n, kiconthemes, kio, kitemmodels, kwindowsystem, mariadb,
  postgresql, qttools, signond, xz,

  mysqlSupport ? true,
  postgresSupport ? false,
  defaultDriver ? if mysqlSupport then "MYSQL" else "POSTGRES",
}:

assert mysqlSupport || postgresSupport;

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
    ki18n kiconthemes kio kwindowsystem xz accounts-qt qttools signond
  ];
  propagatedBuildInputs = [ boost kitemmodels ];
  outputs = [ "out" "dev" ];
  CXXFLAGS = [
    ''-DNIXPKGS_MYSQL_MYSQLD=\"${lib.optionalString mysqlSupport "${lib.getBin mariadb}/bin/mysqld"}\"''
    ''-DNIXPKGS_MYSQL_MYSQLADMIN=\"${lib.optionalString mysqlSupport "${lib.getBin mariadb}/bin/mysqladmin"}\"''
    ''-DNIXPKGS_MYSQL_MYSQL_INSTALL_DB=\"${lib.optionalString mysqlSupport "${lib.getBin mariadb}/bin/mysql_install_db"}\"''
    ''-DNIXPKGS_MYSQL_MYSQLCHECK=\"${lib.optionalString mysqlSupport "${lib.getBin mariadb}/bin/mysqlcheck"}\"''
    ''-DNIXPKGS_POSTGRES_PG_CTL=\"${lib.optionalString postgresSupport "${lib.getBin postgresql}/bin/pg_ctl"}\"''
    ''-DNIXPKGS_POSTGRES_PG_UPGRADE=\"${lib.optionalString postgresSupport "${lib.getBin postgresql}/bin/pg_upgrade"}\"''
    ''-DNIXPKGS_POSTGRES_INITDB=\"${lib.optionalString postgresSupport "${lib.getBin postgresql}/bin/initdb"}\"''
    ''-DNIX_OUT=\"${placeholder "out"}\"''
    ''-I${lib.getDev kio}/include/KF5''  # Fixes: kio_version.h: No such file or directory
  ];

  cmakeFlags = lib.optional (defaultDriver != "MYSQL") "-DDATABASE_BACKEND=${defaultDriver}";

  # compatibility symlinks for kmymoney, can probably be removed in next kde bump
  postInstall = ''
    ln -s $dev/include/KF5/AkonadiCore/Akonadi/Collection $dev/include/KF5/AkonadiCore/Collection
    ln -s $dev/include/KF5/AkonadiCore/Akonadi/ItemFetchScope $dev/include/KF5/AkonadiCore/ItemFetchScope
    ln -s $dev/include/KF5/AkonadiCore/Akonadi/RecursiveItemFetchJob $dev/include/KF5/AkonadiCore/RecursiveItemFetchJob
  '';
}
