{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "snakemake";
  version = "7.29.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Y/z7asYSRgDyDWmvfmX4y6fOMSpp0X9uhDx327YF2TI=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    configargparse
    connection-pool
    datrie
    docutils
    gitpython
    humanfriendly
    jinja2
    jsonschema
    nbformat
    psutil
    pulp
    pyyaml
    requests
    reretry
    smart-open
    stopit
    tabulate
    throttler
    toposort
    wrapt
    yte
  ];

  # See
  # https://github.com/snakemake/snakemake/blob/main/.github/workflows/main.yml#L99
  # for the current basic test suite. Slurm, Tibanna and Tes require extra
  # setup.

  nativeCheckInputs = with python3.pkgs; [
    pandas
    pytestCheckHook
    requests-mock
  ];

  disabledTestPaths = [
    "tests/test_slurm.py"
    "tests/test_tes.py"
    "tests/test_tibanna.py"
    "tests/test_linting.py"
  ];

  disabledTests = [
    # Tests require network access
    "test_github_issue1396"
    "test_github_issue1460"
  ];

  pythonImportsCheck = [
    "snakemake"
  ];

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
