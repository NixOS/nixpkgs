{
  cmake,
  fetchFromGitHub,
  lib,
  nix-update-script,
  runCommand,
  stdenv,
  unixodbc,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "duckdb-odbc";
  version = "1.5.5.0";

  src = fetchFromGitHub {
    owner = "duckdb";
    repo = "duckdb-odbc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uh4Jle/gbHyd4rUfoyW0u35fx9dcvEEzTg8QnuHdiwY=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ unixodbc ];

  strictDeps = true;

  # The upstream build has no install rule; the driver is the single artifact.
  installPhase = ''
    runHook preInstall
    install -Dm755 libduckdb_odbc${stdenv.hostPlatform.extensions.sharedLibrary} \
      -t $out/lib
    runHook postInstall
  '';

  passthru = {
    fancyName = "DuckDB";
    driver = "lib/libduckdb_odbc${stdenv.hostPlatform.extensions.sharedLibrary}";
    updateScript = nix-update-script { };
    tests.isql-query = runCommand "duckdb-odbc-isql-query" { nativeBuildInputs = [ unixodbc ]; } ''
      export ODBCSYSINI=$PWD
      printf '[DuckDB]\nDriver = %s/${finalAttrs.passthru.driver}\n' \
        ${finalAttrs.finalPackage} > odbcinst.ini
      echo "select 41+1 as answer;" \
        | isql -k "Driver=DuckDB;Database=:memory:" -b \
        | grep -F "| 42"
      touch $out
    '';
  };

  meta = {
    homepage = "https://duckdb.org/docs/current/clients/odbc/overview";
    description = "ODBC driver for DuckDB";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers._81reap ];
  };
})
