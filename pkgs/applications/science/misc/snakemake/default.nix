{ lib, stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "snakemake";
  version = "5.28.0";

  propagatedBuildInputs = with python3Packages; [
    appdirs
    ConfigArgParse
    datrie
    docutils
    GitPython
    jsonschema
    nbformat
    psutil
    pulp
    pyyaml
    ratelimiter
    requests
    toposort
    wrapt
  ];

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "2367ce91baf7f8fa7738d33aff9670ffdf5410bbac49aeb209f73b45a3425046";
  };

  doCheck = false; # Tests depend on Google Cloud credentials at ${HOME}/gcloud-service-key.json

  meta = with lib; {
    homepage = "https://snakemake.readthedocs.io";
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
