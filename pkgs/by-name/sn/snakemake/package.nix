{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  stress,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "snakemake";
  version = "9.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake";
    tag = "v${version}";
    hash = "sha256-7XEs+BTy6xPQidbuafrzELvfNjpzU9RcatXpRwHZ+1A=";
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
    snakemake-interface-executor-plugins
    snakemake-interface-common
    snakemake-interface-logger-plugins
    snakemake-interface-storage-plugins
    snakemake-interface-report-plugins
    snakemake-interface-scheduler-plugins
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

  nativeCheckInputs =
    (with python3Packages; [
      numpy
      pandas
      pytestCheckHook
      pytest-mock
      requests-mock
      snakemake-executor-plugin-cluster-generic
      snakemake-storage-plugin-fs
      stress
      versionCheckHook
      polars
    ])
    ++ [ writableTmpDirAsHomeHook ];

  versionCheckProgramArg = "--version";

  enabledTestPaths = [
    "tests/tests.py"
    "tests/test_expand.py"
    "tests/test_io.py"
    "tests/test_schema.py"
    "tests/test_executor_test_suite.py"
    "tests/test_api.py"
  ];

  disabledTests = [
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

    # Require `snakemake-storage-plugin-fs` (circular dependency)
    "test_default_storage"
    "test_default_storage_local_job"
    "test_deploy_sources"
    "test_output_file_cache_storage"
    "test_storage"

    # Tries to access internet
    "test_report_after_run"

    # Needs stress-ng
    "test_benchmark"
    "test_benchmark_jsonl"

    # Needs unshare
    "test_nodelocal"

    # Requires snakemake-storage-plugin-http
    "test_keep_local"
    "test_retrieve"

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
  ];

  pythonImportsCheck = [ "snakemake" ];

  meta = {
    homepage = "https://snakemake.github.io";
    license = lib.licenses.mit;
    description = "Python-based execution environment for make-like workflows";
    changelog = "https://github.com/snakemake/snakemake/blob/${src.tag}/CHANGELOG.md";
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
}
