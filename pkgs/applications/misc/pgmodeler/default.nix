{ lib
, fetchFromGitHub
, pkg-config
, qmake
, mkDerivation
, qtsvg
, postgresql
}:

mkDerivation rec {
  pname = "pgmodeler";
  version = "1.0.0-beta";

  src = fetchFromGitHub {
    owner = "pgmodeler";
    repo = "pgmodeler";
    rev = "v${version}";
    sha256 = "sha256-1+1hKOY8unu6Z7LLv/WQ86JlwWUubQuhPP9OUjyXOrM=";
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
