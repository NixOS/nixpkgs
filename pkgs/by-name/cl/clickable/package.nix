{
  lib,
  fetchFromGitLab,
  gitUpdater,
  python3Packages,
  stdenv,
  docker,
  git,
  which,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "clickable";
  version = "8.7.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "clickable";
    repo = "clickable";
    rev = "v${finalAttrs.version}";
    hash = "sha256-W6NPZ5uP7wGjgyA+Nv2vpmshKWny2CCSrn/Gaoi7Pr4=";
  };

  __structuredAttrs = true;

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    cookiecutter
    requests
    pyyaml
    jsonschema
    argcomplete
    watchdog
  ];

  nativeCheckInputs = [
    docker
    git
    python3Packages.pytestCheckHook
    which
  ];

  disabledTests = [
    # Requires running docker daemon
    "TestTemplates"

    # Expects /tmp to exist and not be a symlink
    # https://gitlab.com/clickable/clickable/-/issues/479
    "TestReviewCommand and test_run and not test_run_with_path_arg"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isx86_64) [
    # pytest's lack of exact nodeid matching or deselecting makes it impossible to nicely disable just
    # test_architectures.py::TestArchitectures::test_arch (infix matching makes test_arch match test_architectures.py).
    # Have to `or` for every other TestArchitectures test and then `not` that.
    # What we want to disable: test_arch & test_restricted_arch
    # Reason: they hardcode amd64
    "TestArchitectures and not (${
      lib.strings.concatStringsSep " or " [
        "test_arch_agnostic"
        "test_default_arch"
        "test_fail_arch_agnostic"
        "test_fail_in_restricted_arch"
        "test_restricted_arch_env"
      ]
    })"

    # no -ide images on non-x86_64
    # https://gitlab.com/clickable/clickable/-/issues/478
    "TestIdeQtCreatorCommand and test_command_overrided"
    "TestIdeQtCreatorCommand and test_init_cmake_project"
    "TestIdeQtCreatorCommand and test_initialize_qtcreator_conf"
    "TestIdeQtCreatorCommand and test_project_pre_configured"
    "TestIdeQtCreatorCommand and test_recurse_replace"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Build system for Ubuntu Touch apps";
    mainProgram = "clickable";
    homepage = "https://clickable-ut.dev";
    changelog = "https://clickable-ut.dev/en/latest/changelog.html#changes-in-v${
      lib.strings.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ilyakooo0 ];
    teams = [ lib.teams.lomiri ];
  };
})
