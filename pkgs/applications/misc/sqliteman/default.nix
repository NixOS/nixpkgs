{ stdenv, fetchurl, qt4, cmake }:

stdenv.mkDerivation rec {
  name = "sqliteman-${version}";
  version = "1.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/sqliteman/sqliteman/${version}/sqliteman-${version}.tar.bz2";
    md5 = "c8197428739bcd86deaafa8ef267e3cb";
  };

  buildInputs = [ cmake qt4 ];

  cmakeFlags = [ "-DWANT_INTERNAL_QSCINTILLA=1" ];

  meta = {
    description = "GUI tool for SQLite3";
    longDescription = ''
      The perfect tool for tuning SQL statements, managing tables, views, and
      triggers; administrating the database space, and getting index statistics.
    '';
    homepage    = "http://sqliteman.com/";
    license     = "GPLv2";

    inherit (qt4.meta) platforms;
  };
}
