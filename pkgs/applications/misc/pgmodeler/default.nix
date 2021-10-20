{ lib
, fetchFromGitHub
, pkg-config
, qmake
, mkDerivation
, qtsvg
, libxml2
, postgresql
}:

mkDerivation rec {
  pname = "pgmodeler";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "pgmodeler";
    repo = "pgmodeler";
    rev = "v${version}";
    sha256 = "1bci5x418dbnkny7hn0b5q5lxyajrgl3frv41ji0hcw9vivrds2g";
  };

  nativeBuildInputs = [ pkg-config qmake ];
  qmakeFlags = [ "pgmodeler.pro" "CONFIG+=release" ];

  # todo: libpq would suffice here. Unfortunately this won't work, if one uses only postgresql.lib here.
  buildInputs = [ postgresql qtsvg ];

  meta = with lib; {
    description = "A database modeling tool for PostgreSQL";
    homepage = "https://pgmodeler.io/";
    license = licenses.gpl3;
    maintainers = [ maintainers.esclear ];
    platforms = platforms.linux;
  };
}
