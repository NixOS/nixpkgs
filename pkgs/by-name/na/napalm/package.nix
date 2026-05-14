{ python3Packages }:
with python3Packages;
toPythonApplication (
  napalm.overridePythonAttrs (attrs: {
    # add community frontends that depend on the napalm python package
    dependencies = attrs.dependencies ++ [
      napalm-hp-procurve
    ];
  })
)
