{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "snakemake";
  version = "6.5.3";

  propagatedBuildInputs = with python3Packages; [
    appdirs
    ConfigArgParse
    connection-pool
    datrie
    docutils
    filelock
    GitPython
    jsonschema
    nbformat
    psutil
    pulp
    pyyaml
    ratelimiter
    requests
    smart-open
    stopit
    tabulate
    toposort
    wrapt
  ];

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "a06839346425c74542e6e2e6047db3133cd747ef89e1ebd87dad1fbba041f62d";
  };

  doCheck = false; # Tests depend on Google Cloud credentials at ${HOME}/gcloud-service-key.json

  meta = with lib; {
    homepage = "https://snakemake.github.io";
    license = licenses.mit;
    description = "Python-based execution environment for make-like workflows";
    longDescription = ''
      Snakemake is a workflow management system that aims to reduce the complexity of
      creating workflows by providing a fast and comfortable execution environment,
      together with a clean and readable specification language in Python style. Snakemake
      workflows are essentially Python scripts extended by declarative code to define
      rules. Rules describe how to create output files from input files.
    '';
    maintainers = with maintainers; [ helkafen renatoGarcia veprbl ];
  };
}
