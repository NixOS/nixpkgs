{
  lib,
  python3Packages,
  # flags for optional dependencies
  enableRustBackend ? true,
  enableMysql ? true,
  enablePostgresql ? true,
}:
python3Packages.toPythonApplication (
  python3Packages.dirsearch.overrideAttrs (prev: {
    propagatedBuildInputs =
      prev.propagatedBuildInputs
      ++ lib.optionals enableRustBackend prev.passthru.optional-dependencies.rustbackend
      ++ lib.optionals enableMysql prev.passthru.optional-dependencies.mysql
      ++ lib.optionals enablePostgresql prev.passthru.optional-dependencies.postgresql;
  })
)
