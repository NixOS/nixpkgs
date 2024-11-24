{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  postgresql,
  openssl,
  withLibiodbc ? false,
  libiodbc,
  withUnixODBC ? true,
  unixODBC,
}:

assert lib.xor withLibiodbc withUnixODBC;

stdenv.mkDerivation rec {
  pname = "psqlodbc";
  version = "${builtins.replaceStrings [ "_" ] [ "." ] (lib.strings.removePrefix "REL-" src.tag)}";

  src = fetchFromGitHub {
    owner = "postgresql-interfaces";
    repo = "psqlodbc";
    tag = "REL-17_00_0002";
    hash = "sha256-zCjoX+Ew8sS5TWkFSgoqUN5ukEF38kq+MdfgCQQGv9w=";
  };

  buildInputs =
    [
      postgresql
      openssl
    ]
    ++ lib.optional withLibiodbc libiodbc
    ++ lib.optional withUnixODBC unixODBC;

  nativeBuildInputs = [
    autoreconfHook
  ];

  passthru = lib.optionalAttrs withUnixODBC {
    fancyName = "PostgreSQL";
    driver = "lib/psqlodbcw.so";
  };

  configureFlags = [
    "--with-libpq=${lib.getDev postgresql}/bin/pg_config"
  ] ++ lib.optional withLibiodbc "--with-iodbc=${libiodbc}";

  meta = with lib; {
    homepage = "https://odbc.postgresql.org/";
    description = "ODBC driver for PostgreSQL";
    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = postgresql.meta.maintainers;
  };
}
