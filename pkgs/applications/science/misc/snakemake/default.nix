{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "snakemake";
  version = "5.19.3";

  propagatedBuildInputs = with python3Packages; [
    appdirs
    ConfigArgParse
    datrie
    docutils
    GitPython
    jsonschema
    nbformat
    psutil
    pyyaml
    ratelimiter
    requests
    toposort
    wrapt
  ];

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "b83f3ef73e25dafcb39b3565030e33fa2f7e80ed70256c535dc7e58ea762305d";
  };

  doCheck = false; # Tests depend on Google Cloud credentials at ${HOME}/gcloud-service-key.json

  meta = with stdenv.lib; {
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
