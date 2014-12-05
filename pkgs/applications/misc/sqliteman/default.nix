{ stdenv, fetchurl, cmake, qt4, qscintilla }:

stdenv.mkDerivation rec {
  name = "sqliteman";
  version = "1.2.0-c41b89e1";

  src = fetchurl {
    url = https://github.com/pvanek/sqliteman/archive/1.2.0.tar.gz;
    sha256 = "1x4ppwf01jdnz3a4ycia6vv5qf3w2smbqx690z1pnkwbvk337akm";
  };

  buildInputs = [ cmake qt4 qscintilla ];

  prePatch = ''
    sed -i 's,m_file(0),m_file(QString()),' Sqliteman/sqliteman/main.cpp
  '';

  preConfigure = ''
    cd Sqliteman
    sed -i 's,/usr/include/Qsci,${qscintilla}/include/Qsci,' cmake/modules/FindQScintilla.cmake
    sed -i 's,PATHS ''${QT_LIBRARY_DIR},PATHS ${qscintilla}/libs,' cmake/modules/FindQScintilla.cmake
  '';

  meta = with stdenv.lib; {
    description = "Sqliteman is simple but powerfull Sqlite3 GUI database manager.";
    homepage = http://sqliteman.yarpen.cz/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eikek ];
  };
}
