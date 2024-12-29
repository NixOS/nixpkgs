{ python3Packages, writers }:

let
  py = python3Packages;

  gunicornScript = writers.writePython3 "gunicornMlflow" { } ''
    import re
    import sys
    from gunicorn.app.wsgiapp import run
    if __name__ == '__main__':
        sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', ''', sys.argv[0])
        sys.exit(run())
  '';
in
py.toPythonApplication (
  py.mlflow.overridePythonAttrs (old: {

    propagatedBuildInputs = old.dependencies ++ [
      py.boto3
      py.mysqlclient
    ];

    postPatch =
      (old.postPatch or "")
      + ''
        cat mlflow/utils/process.py

        substituteInPlace mlflow/utils/process.py --replace-fail \
          "process = subprocess.Popen(" \
          "cmd[0]='${gunicornScript}'; process = subprocess.Popen("
      '';

    postInstall = ''
      gpath=$out/bin/gunicornMlflow
      cp ${gunicornScript} $gpath
      chmod 555 $gpath
    '';
  })
)
