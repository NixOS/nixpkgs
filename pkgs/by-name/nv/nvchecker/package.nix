{ python3Packages }:
with python3Packages;
toPythonApplication (
  nvchecker.overridePythonAttrs (oldAttrs: {
    propagatedBuildInputs =
      oldAttrs.dependencies ++ lib.concatAttrValues oldAttrs.optional-dependencies;
  })
)
