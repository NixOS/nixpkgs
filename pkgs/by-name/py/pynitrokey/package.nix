{ python3 }:

with python3.pkgs;
toPythonApplication (
  pynitrokey.overridePythonAttrs (old: {
    dependencies = old.dependencies ++ pynitrokey.passthru.optional-dependencies.pcsc;
  })
)
