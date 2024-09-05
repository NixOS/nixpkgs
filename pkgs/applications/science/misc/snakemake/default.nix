{ lib
, fetchFromGitHub
, fetchpatch
, fetchurl
, python3
, runtimeShell
, stress
}:

python3.pkgs.buildPythonApplication rec {
  pname = "snakemake";
  version = "8.19.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DWlMF/aNRCYDfTP41ALaGJFBTBjHxqZtx/0PtD/37KY=";
    # https://github.com/python-versioneer/python-versioneer/issues/217
    postFetch = ''
      sed -i "$out"/snakemake/_version.py -e 's#git_refnames = ".*"#git_refnames = " (tag: v${version})"#'
    '';
  };

  patches = [
    # Avoid downloading if files are provided
    # https://github.com/snakemake/snakemake/pull/3072
    (fetchpatch {
      url = "https://github.com/snakemake/snakemake/commit/ea89ec2f20faa0db303fdab0eafa640c9147cc14.diff";
      hash = "sha256-gzmto3Kusk40kPH29DkvYcJgAx2VAOq3mw5vPSCp5mI=";
    })
  ];

  postPatch = ''
    patchShebangs --build tests/
    substituteInPlace tests/common.py \
      --replace-fail 'os.environ["PYTHONPATH"] = os.getcwd()' "pass" \
      --replace-fail 'del os.environ["PYTHONPATH"]' "pass"
    substituteInPlace snakemake/unit_tests/__init__.py \
      --replace-fail '"unit_tests/templates"' '"'"$PWD"'/snakemake/unit_tests/templates"'
  '' + (let
    assets = import ./assets.nix { inherit fetchurl; };
  in
    # Use fetchPypi once https://github.com/snakemake/snakemake/pull/3073 is available
    lib.concatStrings (lib.mapAttrsToList (name: file: ''
      echo install -D "${file}" snakemake/assets/data/${name}
      install -D "${file}" snakemake/assets/data/${name}
    '') assets));

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
    # requires network connection
    "test_deploy_sources"
    "test_modules_meta_wrapper"
    "test_module_complex"
    "test_module_complex2"
    "test_module_with_script"
    "test_module_report"
    "test_load_metawrapper"
    # requires conda
    "test_archive"
    "test_script"
    "test_conda"
    "test_conda_list_envs"
    "test_upstream_conda"
    "test_deploy_script"
    "test_deploy_hashing"
    "test_conda_custom_prefix"
    "test_conda_cmd_exe"
    "test_wrapper"
    "test_wrapper_local_git_prefix"
    "test_singularity_conda"
    "test_issue635"
    "test_issue1093"
    "test_jupyter_notebook"
    "test_jupyter_notebook_draft"
    "test_converting_path_for_r_script"
    "test_conda_named"
    "test_conda_function"
    "test_conda_pin_file"
    "test_conda_python_script"
    "test_conda_python_3_7_script"
    "test_prebuilt_conda_script"
    "test_conda_global"
    "test_script_pre_py39"
    "test_resource_string_in_cli_or_profile"
    "test_conda"
    "test_env_modules"
    "test_script_pre_py39"
    # requires graphviz
    "test_filegraph"
    # requires s3
    "test_storage"
    "test_default_storage"
    "test_output_file_cache_storage"
    # requires peppy and eido
    "test_pep"
    # requires perl
    "test_shadow"
    # requires snakemake-storage-plugin-http
    "test_ancient"
    "test_modules_prefix"
    # weird
    "test_strict_mode"
    "test_issue1256"
    "test_issue2574"
    # requires apptainer
    "test_singularity"
    "test_singularity_cluster"
    "test_singularity_invalid"
    "test_singularity_module_invalid"
    "test_singularity_none"
    "test_singularity_global"
    "test_cwl_singularity"
    "test_issue1083"
    "test_github_issue78"
    "test_container"
    "test_shell_exec"
    "test_containerized"
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

  passthru.updateScript = ./update.sh;

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
