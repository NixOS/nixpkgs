{ python3Packages, python3 }:

let
  py = python3Packages;
  mlflowPythonEnv = python3.withPackages (ps: [
    ps.mlflow
  ]);
in
py.toPythonApplication (
  py.mlflow.overridePythonAttrs (old: {

    propagatedBuildInputs = old.dependencies ++ [
      py.boto3
      py.mysqlclient
    ];

    postPatch = (old.postPatch or "") + ''
      substituteInPlace mlflow/utils/process.py --replace-fail \
        "process = subprocess.Popen(" \
        "cmd[0]='${mlflowPythonEnv.interpreter}'; process = subprocess.Popen("
    '';
  })
)
