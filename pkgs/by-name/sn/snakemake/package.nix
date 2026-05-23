{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  stress,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  snakemake,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "snakemake";
  version = "9.21.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+EO+BTMkui0mJvEf0TOaCRBH8MzLsit8xK+71gujHt0=";
  };

  postPatch = ''
    patchShebangs --build tests/
    substituteInPlace tests/common.py \
      --replace-fail 'os.environ["PYTHONPATH"] = os.getcwd()' "pass" \
      --replace-fail 'del os.environ["PYTHONPATH"]' "pass"
    substituteInPlace src/snakemake/unit_tests/__init__.py \
      --replace-fail '"unit_tests/templates"' '"'"$PWD"'/snakemake/unit_tests/templates"'
    substituteInPlace src/snakemake/assets/__init__.py \
      --replace-fail "raise err" "return bytes('err','ascii')"
  '';

  build-system = with python3Packages; [ setuptools-scm ];

  pythonRelaxDeps = [
    "packaging"
    "sqlmodel"
  ];
  dependencies = with python3Packages; [
    appdirs
    conda-inject
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
    snakemake-interface-common
    snakemake-interface-executor-plugins
    snakemake-interface-logger-plugins
    snakemake-interface-report-plugins
    snakemake-interface-scheduler-plugins
    snakemake-interface-storage-plugins
    sqlmodel
    stopit
    tabulate
    tenacity
    throttler
    toposort
    wrapt
    yte
  ];

  pythonImportsCheck = [ "snakemake" ];

  # See
  # https://github.com/snakemake/snakemake/blob/main/.github/workflows/main.yml#L99
  # for the current basic test suite. Slurm, Tibanna and Tes require extra
  # setup.

  nativeCheckInputs =
    (with python3Packages; [
      numpy
      pandas
      pytestCheckHook
      pytest-mock
      requests-mock
      snakemake-executor-plugin-cluster-generic
      snakemake-storage-plugin-fs
      snakemake-storage-plugin-http
      snakemake-storage-plugin-s3
      stress
      polars
    ])
    ++ [
      versionCheckHook
      writableTmpDirAsHomeHook
    ];

  enabledTestPaths = [
    "tests/tests.py"
    "tests/test_expand.py"
    "tests/test_io.py"
    "tests/test_schema.py"
    "tests/test_executor_test_suite.py"
    "tests/test_api.py"
  ];

  disabledTests = [
    # AssertionError: expected file "onerror_module2.log" not produced
    "test_module_onerror"

    # FAILED tests/tests.py::test_env_modules - AssertionError: expected successful execution
    "test_ancient"
    "test_conda_create_envs_only"
    "test_env_modules"
    "test_generate_unit_tests"
    "test_modules_prefix"
    "test_strict_mode"
    # Requires perl
    "test_shadow"
    # Require peppy and eido
    "test_peppy"
    "test_modules_peppy"
    "test_pep_pathlib"

    # CalledProcessError
    "test_filegraph" # requires graphviz
    "test_github_issue1384"

    # AssertionError: assert 127 == 1
    "test_issue1256"
    "test_issue2574"

    # Tries to access internet
    "test_report_after_run"

    # Needs stress-ng
    "test_benchmark"
    "test_benchmark_jsonl"

    # Needs unshare
    "test_nodelocal"

    # Requires conda
    "test_jupyter_notebook"
    "test_jupyter_notebook_nbconvert"
    "test_jupyter_notebook_draft"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Unclear failure:
    # AssertionError: expected successful execution
    # `__darwinAllowLocalNetworking` doesn't help
    "test_excluded_resources_not_submitted_to_cluster"
    "test_group_job_resources_with_pipe"
    "test_group_jobs_resources"
    "test_group_jobs_resources_with_limited_resources"
    "test_group_jobs_resources_with_max_threads"
    "test_issue850"
    "test_issue860"
    "test_multicomp_group_jobs"
    "test_queue_input"
    "test_queue_input_dryrun"
    "test_queue_input_forceall"
    "test_resources_submitted_to_cluster"
    "test_scopes_submitted_to_cluster"

    # Issue with /dev/stderr in sandbox
    "test_protected_symlink_output"

    # Unclear issue:
    #   pulp.apis.core.PulpSolverError: Pulp: cannot execute cbc cwd:
    # but pulp solver is not default
    "test_access_patterns"

    # Hangs with no sandbox, skips due to no network with sandbox relaxed/on
    "test_modules_meta_wrapper"

    # Hangs
    # https://github.com/snakemake/snakemake/issues/3939
    "test_issue1331"
  ];

  # Circular dependencies
  doCheck = false;
  passthru.tests.pytest = snakemake.overridePythonAttrs {
    doCheck = true;
  };

  meta = {
    homepage = "https://snakemake.github.io";
    license = lib.licenses.mit;
    description = "Python-based execution environment for make-like workflows";
    changelog = "https://github.com/snakemake/snakemake/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    mainProgram = "snakemake";
    longDescription = ''
      Snakemake is a workflow management system that aims to reduce the complexity of
      creating workflows by providing a fast and comfortable execution environment,
      together with a clean and readable specification language in Python style. Snakemake
      workflows are essentially Python scripts extended by declarative code to define
      rules. Rules describe how to create output files from input files.
    '';
    maintainers = with lib.maintainers; [
      helkafen
      renatoGarcia
      veprbl
    ];
  };
})
