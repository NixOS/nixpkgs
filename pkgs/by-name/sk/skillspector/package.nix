{
  python3Packages,
  tests,
}:
python3Packages.toPythonApplication (
  python3Packages.skillspector.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies ++ oldAttrs.optional-dependencies.full;
    passthru.tests.integration = tests.skillspector;
  })
)
