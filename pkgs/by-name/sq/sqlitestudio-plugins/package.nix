{
  stdenv,
  lib,
  python3,

  sqlitestudio,
}:
stdenv.mkDerivation {
  pname = "sqlitestudio-plugins";

  inherit (sqlitestudio)
    version
    src
    nativeBuildInputs
    buildInputs
    ;

  postConfigure = ''
    uic ./SQLiteStudio3/guiSQLiteStudio/mainwindow.ui -o ./SQLiteStudio3/guiSQLiteStudio/ui_mainwindow.h
  '';

  qmakeFlags = [
    "./Plugins"
    "PYTHON_VERSION=${python3.pythonVersion}"
    "INCLUDEPATH+=${python3}/include/python${python3.pythonVersion}"
  ];

  # bin/ld: final link failed: bad value
  enableParallelBuilding = false;

  meta = sqlitestudio.meta // {
    description = "Official plugins for SQLiteStudio, a free, open source, multi-platform SQLite database manager";
    badPlatforms = [ lib.systems.inspect.platformPatterns.isStatic ];
  };
}
