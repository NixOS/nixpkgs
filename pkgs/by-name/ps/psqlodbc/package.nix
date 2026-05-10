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
  unixodbc,
}:

assert lib.xor withLibiodbc withUnixODBC;

stdenv.mkDerivation (finalAttrs: {
  pname = "psqlodbc";
  version = "17.00.0008";

  src = fetchFromGitHub {
    owner = "postgresql-interfaces";
    repo = "psqlodbc";
    tag = "REL-${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-eYt4RwnYfSHz2nGBW94Gkdt3E+j6eS1Ky2KPol3cLkI=";
  };

  buildInputs = [
    libpq
    openssl
  ]
  ++ lib.optional withLibiodbc libiodbc
  ++ lib.optional withUnixODBC unixodbc;

  nativeBuildInputs = [
    autoreconfHook
  ];

  strictDeps = true;

  configureFlags = [
    "CPPFLAGS=-DSQLCOLATTRIBUTE_SQLLEN" # needed for cross
    "--with-libpq=${lib.getDev libpq}"
  ]
  ++ lib.optional withLibiodbc "--with-iodbc=${libiodbc}"
  ++ lib.optional withUnixODBC "--with-unixodbc=${unixodbc}";

  passthru = {
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
