{
  python3Packages,
}:

# The application serves every output the NixOS module can configure, so it carries every extra
python3Packages.toPythonApplication (
  python3Packages.parsedmarc.overridePythonAttrs (old: {
    dependencies = old.dependencies ++ python3Packages.parsedmarc.optional-dependencies.all;
  })
)
