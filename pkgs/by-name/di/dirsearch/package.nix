{
  lib,
  python3Packages,
  # flags for optional dependencies
  withRustBackend ? true,
  withDbDeps ? true,
}:

python3Packages.toPythonApplication (
  python3Packages.dirsearch.overridePythonAttrs (prevAttrs: {
    dependencies =
      prevAttrs.dependencies or [ ]
      ++ lib.optionals withRustBackend prevAttrs.optional-dependencies.rustbackend
      ++ lib.optionals withDbDeps prevAttrs.optional-dependencies.db;
  })
)
