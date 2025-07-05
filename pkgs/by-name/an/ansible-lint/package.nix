{
  lib,
  python3Packages,
  fetchPypi,
  ansible,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "ansible-lint";
  version = "25.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "ansible_lint";
    hash = "sha256-QYJSDyM+70JIvEz0tgdOJc2vW+Ic+b6USqvIXfVAfpw=";
  };

  postPatch = ''
    # it is fine if lint tools are missing
    substituteInPlace conftest.py \
      --replace-fail "sys.exit(1)" ""
  '';

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    # https://github.com/ansible/ansible-lint/blob/master/.config/requirements.in
    ansible-core
    ansible-compat
    black
    filelock
    importlib-metadata
    jsonschema
    packaging
    pyyaml
    rich
    ruamel-yaml
    subprocess-tee
    wcmatch
    yamllint
  ];

  pythonRelaxDeps = [ "ruamel.yaml" ];

  # tests can't be easily run without installing things from ansible-galaxy
  doCheck = false;

  nativeCheckInputs =
    with python3Packages;
    [
      flaky
      pytest-xdist
      pytestCheckHook
    ]
    ++ [
      writableTmpDirAsHomeHook
      ansible
    ];

  preCheck = ''
    # create a working ansible-lint executable
    export PATH=$PATH:$PWD/src/ansiblelint
    ln -rs src/ansiblelint/__main__.py src/ansiblelint/ansible-lint
    patchShebangs src/ansiblelint/__main__.py

    # create symlink like in the git repo so test_included_tasks does not fail
    ln -s ../roles examples/playbooks/roles
  '';

  disabledTests = [
    # requires network
    "test_cli_auto_detect"
    "test_install_collection"
    "test_prerun_reqs_v1"
    "test_prerun_reqs_v2"
    "test_require_collection_wrong_version"
    # re-execs ansible-lint which does not works correct
    "test_custom_kinds"
    "test_run_inside_role_dir"
    "test_run_multiple_role_path_no_trailing_slash"
    "test_runner_exclude_globs"
    "test_discover_lintables_umlaut"
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ansible ]}" ];

  meta = {
    description = "Best practices checker for Ansible";
    mainProgram = "ansible-lint";
    homepage = "https://github.com/ansible/ansible-lint";
    changelog = "https://github.com/ansible/ansible-lint/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sengaya
      HarisDotParis
    ];
  };
}
