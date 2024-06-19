{ lib
, fetchFromGitHub
, python3
, runtimeShell
}:

python3.pkgs.buildPythonApplication rec {
  pname = "snakemake";
  version = "8.11.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-00Zh8NenBikdingmx34WYYH5SF+yazeAs+7h1/3UIJY=";
    # https://github.com/python-versioneer/python-versioneer/issues/217
    postFetch = ''
      sed -i "$out"/snakemake/_version.py -e 's#git_refnames = ".*"#git_refnames = " (tag: v${version})"#'
    '';
  };

  postPatch = ''
    patchShebangs --build tests/
    patchShebangs --host snakemake/executors/jobscript.sh
    substituteInPlace snakemake/shell.py \
      --replace "/bin/sh" "${runtimeShell}"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    configargparse
    connection-pool
    datrie
    docutils
    gitpython
    humanfriendly
    immutables
    jinja2
    jsonschema
    nbformat
    psutil
    pulp
    pyyaml
    requests
    reretry
    smart-open
    snakemake-interface-executor-plugins
    snakemake-interface-common
    snakemake-interface-storage-plugins
    snakemake-interface-report-plugins
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
    numpy
    pandas
    pytestCheckHook
    requests-mock
    snakemake-executor-plugin-cluster-generic
  ];

  disabledTestPaths = [
    "tests/test_conda_python_3_7_script/test_script.py"
  ];

  disabledTests = [
    "test_deploy_sources"
  ];

  pythonImportsCheck = [
    "snakemake"
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  meta = with lib; {
    homepage = "https://snakemake.github.io";
    license = licenses.mit;
    description = "Python-based execution environment for make-like workflows";
    mainProgram = "snakemake";
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
