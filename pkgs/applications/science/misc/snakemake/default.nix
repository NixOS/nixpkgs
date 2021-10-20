{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "snakemake";
  version = "6.7.0";

  propagatedBuildInputs = with python3Packages; [
    appdirs
    configargparse
    connection-pool
    datrie
    docutils
    filelock
    GitPython
    jinja2
    jsonschema
    nbformat
    networkx
    psutil
    pulp
    pygraphviz
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
    sha256 = "6f53d54044c5d1718c7858f45286beeffb220c794fe5f602a5c20bf0caf8ec07";
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
