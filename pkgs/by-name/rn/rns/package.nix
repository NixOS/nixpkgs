{
  lib,
  python3Packages,
}:

python3Packages.toPythonApplication (
  python3Packages.rns.overridePythonAttrs (old: {
    dependencies = old.dependencies ++ lib.concatAttrValues old.optional-dependencies;
    dontUsePythonCatchConflicts = true;
  })
)
