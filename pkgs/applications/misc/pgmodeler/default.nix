{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, pkg-config
, qmake
, qtwayland
, qtsvg
, postgresql
}:

stdenv.mkDerivation rec {
  pname = "pgmodeler";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "pgmodeler";
    repo = "pgmodeler";
    rev = "v${version}";
    sha256 = "sha256-urKAsuYmK8dsXhP+I7p27PXXYRapPtkI8FqARfLwnEw=";
  };

  nativeBuildInputs = [ pkg-config qmake wrapQtAppsHook ];
  qmakeFlags = [ "pgmodeler.pro" "CONFIG+=release" ];

  # todo: libpq would suffice here. Unfortunately this won't work, if one uses only postgresql.lib here.
  buildInputs = [ postgresql qtsvg qtwayland ];

  meta = with lib; {
    description = "A database modeling tool for PostgreSQL";
    homepage = "https://pgmodeler.io/";
    license = licenses.gpl3;
    maintainers = [ maintainers.esclear ];
    platforms = platforms.linux;
  };
}
