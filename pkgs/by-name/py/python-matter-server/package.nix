{ python3Packages }:
with python3Packages;
toPythonApplication (
  python-matter-server.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies ++ oldAttrs.optional-dependencies.server;
  })
)
