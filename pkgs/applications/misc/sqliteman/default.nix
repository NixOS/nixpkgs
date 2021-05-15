{ lib, stdenv, fetchFromGitHub, cmake, qt4, qscintilla }:

stdenv.mkDerivation rec {
  pname = "sqliteman";
  version = "1.2.0";

  src = fetchFromGitHub {
    repo = "sqliteman";
    owner = "pvanek";
    rev = version;
    sha256 = "1blzyh1646955d580f71slgdvz0nqx0qacryx0jc9w02yrag17cs";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt4 qscintilla ];

  prePatch = ''
    sed -i 's,m_file(0),m_file(QString()),' Sqliteman/sqliteman/main.cpp
  '';

  preConfigure = ''
    cd Sqliteman
    sed -i 's,/usr/include/Qsci,${qscintilla}/include/Qsci,' cmake/modules/FindQScintilla.cmake
    sed -i 's,PATHS ''${QT_LIBRARY_DIR},PATHS ${qscintilla}/libs,' cmake/modules/FindQScintilla.cmake
  '';

  meta = with lib; {
    description = "A simple but powerful Sqlite3 GUI database manager";
    homepage = "http://sqliteman.yarpen.cz/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eikek ];
  };
}
