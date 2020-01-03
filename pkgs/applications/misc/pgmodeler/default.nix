{ stdenv, lib, fetchFromGitHub, pkgconfig, qmake, mkDerivation,
  qtsvg,
  libxml2, postgresql }:

mkDerivation rec {
  pname = "pgmodeler";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "pgmodeler";
    repo = "pgmodeler";
    rev = "v${version}";
    sha256 = "15isnbli9jj327r6sj7498nmhgf1mzdyhc1ih120ibw4900aajiv";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig qmake ];
  qmakeFlags = [ "pgmodeler.pro" "CONFIG+=release" ];

  # todo: libpq would suffice here. Unfortunately this won't work, if one uses only postgresql.lib here.
  buildInputs = [ postgresql qtsvg ];

  meta = with stdenv.lib; {
    description = "A database modeling tool for PostgreSQL";
    longDescription = ''pgModeler (PostgreSQL Database Modeler) is an open source database modeling tool designed for PostgreSQL.'';
    homepage = https://pgmodeler.io/;
    license = licenses.gpl3;
    maintainers = [ maintainers.esclear ];
    platforms = platforms.linux;
  };
}