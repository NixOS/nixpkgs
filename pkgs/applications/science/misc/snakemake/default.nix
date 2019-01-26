{
  stdenv
, python
}:

python.buildPythonPackage rec {
  pname = "snakemake";
  version = "5.2.2";

  propagatedBuildInputs = with python; [
    appdirs
    ConfigArgParse
    datrie
    docutils
    jsonschema
    pyyaml
    ratelimiter
    requests
    wrapt
  ];

  src = python.fetchPypi {
    inherit pname version;
    sha256 = "adffe7e24b4a613a9e8bf0a2a320b3cea236d86afb9132bb0bbbc08b8e35a3a3";
  };

  doCheck = false; # Tests depend on Google Cloud credentials at ${HOME}/gcloud-service-key.json

  meta = with stdenv.lib; {
    homepage = http://snakemake.bitbucket.io;
    license = licenses.mit;
    description = "Python-based execution environment for make-like workflows";
    longDescription = ''
      Snakemake is a workflow management system that aims to reduce the complexity of
      creating workflows by providing a fast and comfortable execution environment,
      together with a clean and readable specification language in Python style. Snakemake
      workflows are essentially Python scripts extended by declarative code to define
      rules. Rules describe how to create output files from input files.
    '';
    maintainers = with maintainers; [ helkafen renatoGarcia ];
  };
}
