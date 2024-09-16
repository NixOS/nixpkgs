{ lib
, fetchPypi
, fetchpatch
, python3
, runtimeShell
, stress
}:

python3.pkgs.buildPythonApplication rec {
  pname = "snakemake";
  version = "8.20.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-adNwIA1z/TwWsa0gQb4hAsUvHInjd30sm1dYKXvvXy8=";
  };

  postPatch = ''
    patchShebangs --build tests/
    substituteInPlace tests/common.py \
      --replace-fail 'os.environ["PYTHONPATH"] = os.getcwd()' "pass" \
      --replace-fail 'del os.environ["PYTHONPATH"]' "pass"
    substituteInPlace snakemake/unit_tests/__init__.py \
      --replace-fail '"unit_tests/templates"' '"'"$PWD"'/snakemake/unit_tests/templates"'
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
    pygments
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
    pytest-mock
    requests-mock
    snakemake-executor-plugin-cluster-generic
    snakemake-storage-plugin-fs
    stress
  ];

  pytestFlagsArray = [
    "tests/tests.py"
    "tests/test_expand.py"
    "tests/test_io.py"
    "tests/test_schema.py"
    "tests/test_executor_test_suite.py"
    "tests/test_api.py"
  ];

  # Some will be disabled via https://github.com/snakemake/snakemake/pull/3074
  disabledTests = [
    # requires graphviz
    "test_filegraph"
    # requires s3
    "test_storage"
    "test_default_storage"
    "test_output_file_cache_storage"
    # requires peppy and eido
    "test_pep"
    "test_modules_peppy"
    # requires perl
    "test_shadow"
    # requires snakemake-storage-plugin-http
    "test_ancient"
    "test_modules_prefix"
    # requires snakemake-storage-plugin-s3
    "test_deploy_sources"
    # requires modules
    "test_env_modules"
    # issue with locating template file
    "test_generate_unit_tests"
    # weird
    "test_strict_mode"
    "test_issue1256"
    "test_issue2574"
    "test_github_issue1384"
    # future-proofing
    "conda"
    "singularity"
    "apptainer"
    "container"
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
