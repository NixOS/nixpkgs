{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  libpq,
  nix-update-script,
  openssl,
  stdenv,

  withLibiodbc ? false,
  libiodbc,

  withUnixODBC ? true,
  unixODBC,
}:

assert lib.xor withLibiodbc withUnixODBC;

stdenv.mkDerivation (finalAttrs: {
  pname = "psqlodbc";
  version = "17.00.0002";

  src = fetchFromGitHub {
    owner = "postgresql-interfaces";
    repo = "psqlodbc";
    tag = "REL-${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-zCjoX+Ew8sS5TWkFSgoqUN5ukEF38kq+MdfgCQQGv9w=";
  };

  buildInputs =
    [
      libpq
      openssl
    ]
    ++ lib.optional withLibiodbc libiodbc
    ++ lib.optional withUnixODBC unixODBC;

  nativeBuildInputs = [
    autoreconfHook
  ];

  strictDeps = true;

  configureFlags =
    [
      "CPPFLAGS=-DSQLCOLATTRIBUTE_SQLLEN" # needed for cross
      "--with-libpq=${lib.getDev libpq}"
    ]
    ++ lib.optional withLibiodbc "--with-iodbc=${libiodbc}"
    ++ lib.optional withUnixODBC "--with-unixodbc=${unixODBC}";

  passthru =
    {
      updateScript = nix-update-script {
        extraArgs = [ "--version-regex=^REL-(\\d+)_(\\d+)_(\\d+)$" ];
      };
    }
    // lib.optionalAttrs withUnixODBC {
      fancyName = "PostgreSQL";
      driver = "lib/psqlodbcw.so";
    };

  meta = {
    homepage = "https://odbc.postgresql.org/";
    description = "ODBC driver for PostgreSQL";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
    teams = libpq.meta.teams;
  };
})
