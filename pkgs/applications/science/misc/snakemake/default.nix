{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "snakemake";
  version = "6.15.5";

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

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-i8C7gPLzUzSxNH9xwpr+fUKI1SvpYFsFBlspS74LoWU=";
  };

  # See
  # https://github.com/snakemake/snakemake/blob/main/.github/workflows/main.yml#L99
  # for the current basic test suite. Tibanna and Tes require extra
  # setup.

  checkInputs = with python3Packages; [
    pandas
    pytestCheckHook
    requests-mock
  ];

  disabledTestPaths = [
    "tests/test_tes.py"
    "tests/test_tibanna.py"
    "tests/test_linting.py"
  ];

  pythonImportsCheck = [ "snakemake" ];

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
