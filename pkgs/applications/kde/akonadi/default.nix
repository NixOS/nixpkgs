{
  mkDerivation, copyPathsToStore, lib,
  extra-cmake-modules,
  kcompletion, kconfigwidgets, kdbusaddons, kdesignerplugin, kiconthemes,
  kwindowsystem, kcrash, kio,
  boost, kitemmodels, shared_mime_info,
  mysql
}:

mkDerivation {
  name = "akonadi";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcompletion kconfigwidgets kdbusaddons kdesignerplugin kiconthemes kio
    kwindowsystem kcrash shared_mime_info
  ];
  propagatedBuildInputs = [ boost kitemmodels ];
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
