{
  python3Packages,
}:

python3Packages.toPythonApplication (
  python3Packages.heudiconv.overridePythonAttrs (old: {
    # for --with-prov option:
    dependencies = old.dependencies ++ [ python3Packages.rdflib ];
  })
)
