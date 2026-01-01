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
<<<<<<< HEAD
  version = "17.00.0007";
=======
  version = "17.00.0006";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "postgresql-interfaces";
    repo = "psqlodbc";
    tag = "REL-${lib.replaceString "." "_" finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-KlAGA+oNV/jJpcDJNGzsq/n55QKhUwTwhfNJ6QL6Pas=";
=======
    hash = "sha256-iu1PWkfOyWtMmy7/8W+acu8v+e8nUPkCIHtVNZ8HzRg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [
    libpq
    openssl
  ]
  ++ lib.optional withLibiodbc libiodbc
  ++ lib.optional withUnixODBC unixODBC;

  nativeBuildInputs = [
    autoreconfHook
  ];

  strictDeps = true;

  configureFlags = [
    "CPPFLAGS=-DSQLCOLATTRIBUTE_SQLLEN" # needed for cross
    "--with-libpq=${lib.getDev libpq}"
  ]
  ++ lib.optional withLibiodbc "--with-iodbc=${libiodbc}"
  ++ lib.optional withUnixODBC "--with-unixodbc=${unixODBC}";

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
