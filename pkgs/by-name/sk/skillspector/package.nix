{ python3Packages }:
python3Packages.toPythonApplication (
  python3Packages.skillspector.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies ++ oldAttrs.optional-dependencies.full;
  })
)
