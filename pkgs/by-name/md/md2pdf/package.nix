{
  python3Packages,
}:

python3Packages.toPythonApplication (
  python3Packages.md2pdf.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies ++ oldAttrs.optional-dependencies.cli;
  })
)
