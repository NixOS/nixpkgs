{
  python3Packages,
}:

python3Packages.toPythonApplication (
  python3Packages.intensity-normalization.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies ++ oldAttrs.optional-dependencies.ants;
  })
)
