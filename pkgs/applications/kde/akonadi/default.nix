{
  mkDerivation, copyPathsToStore, lib, kdepimTeam,
  extra-cmake-modules, shared_mime_info,
  boost, kcompletion, kconfigwidgets, kcrash, kdbusaddons, kdesignerplugin,
  ki18n, kiconthemes, kio, kitemmodels, kwindowsystem, mysql, qttools,
}:

mkDerivation {
  name = "akonadi";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = kdepimTeam;
  };
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ extra-cmake-modules shared_mime_info ];
  buildInputs = [
    kcompletion kconfigwidgets kcrash kdbusaddons kdesignerplugin ki18n
    kiconthemes kio kwindowsystem qttools
  ];
  propagatedBuildInputs = [ boost kitemmodels ];
  outputs = [ "out" "dev" ];
  cmakeFlags = [
    "-DMYSQLD_EXECUTABLE=${lib.getBin mysql}/bin/mysqld"
  ];
  NIX_CFLAGS_COMPILE = [
    ''-DNIXPKGS_MYSQL_MYSQLD="${lib.getBin mysql}/bin/mysqld"''
    ''-DNIXPKGS_MYSQL_MYSQLADMIN="${lib.getBin mysql}/bin/mysqladmin"''
    ''-DNIXPKGS_MYSQL_MYSQL_INSTALL_DB="${lib.getBin mysql}/bin/mysql_install_db"''
    ''-DNIXPKGS_MYSQL_MYSQLCHECK="${lib.getBin mysql}/bin/mysqlcheck"''
    ''-DNIXPKGS_POSTGRES_PG_CTL=""''
    ''-DNIXPKGS_POSTGRES_INITDB=""''
  ];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIX_OUT=\"$out\""
  '';
}
