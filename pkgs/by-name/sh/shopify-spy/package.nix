{ python3Packages }:

# The CLI includes the excel extra, so --format xlsx works
python3Packages.toPythonApplication (
  python3Packages.shopify-spy.overridePythonAttrs (old: {
    dependencies = old.dependencies ++ old.optional-dependencies.excel;
  })
)
