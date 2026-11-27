{ python3Packages }:

python3Packages.toPythonApplication (
  python3Packages.mlflow.overridePythonAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
      python3Packages.boto3
      python3Packages.mysqlclient
    ];
    meta = old.meta // {
      hasNoMaintainersButDependents = false;
    };
  })
)
