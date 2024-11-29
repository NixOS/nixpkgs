{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, shared-mime-info, accounts-qt,
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

  postInstall = ''
    # added as an include directory by cmake files and fails to compile if it's missing
    mkdir -p "$dev/include/KF5"
  '';
}
