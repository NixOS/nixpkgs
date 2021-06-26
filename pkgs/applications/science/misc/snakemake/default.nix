{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "snakemake";
  version = "6.5.0";

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
    sha256 = "b166ec74537e02553fcaf0ddcffc32dfdb9dcaa1260af297a56eded6a179b2ee";
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
