{ stdenv, fetchFromBitbucket, python }:

let
  version = "5.2.2";
  sha256 = "08nf0kfkj9wipaskmxpsv3ndha0wgkmmgb2hpdkkkzdz6n3l9bkq";
in python.buildPythonApplication {
  inherit version;
  pname = "snakemake";

  src = fetchFromBitbucket {
    owner = "snakemake";
    repo = "snakemake";
    rev = "v${version}";
    inherit sha256;
  };

  doCheck = false;

  propagatedBuildInputs = [
    python.appdirs
    python.datrie
    python.ConfigArgParse
    python.pyyaml
    python.jsonschema
    python.ratelimiter
    python.docutils
    python.wrapt
    python.requests
  ];

  meta = with stdenv.lib; {
    homepage = https://snakemake.bitbucket.io;
    description = "Workflow management system that aims to reduce the complexity of creating workflows.";
    license = licenses.mit;
    longDescription = ''
      Snakemake is a workflow management system that aims to reduce the complexity of
      creating workflows by providing a fast and comfortable execution environment,
      together with a clean and readable specification language in Python style. Snakemake
      workflows are essentially Python scripts extended by declarative code to define
      rules. Rules describe how to create output files from input files.
    '';
    platforms = platforms.all;
    maintainers = [ maintainers.renatoGarcia ];
  };
}
