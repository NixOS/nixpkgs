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
  version = "8.10.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "clickable";
    repo = "clickable";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OCwGaV4IsX2Tcd8vcCZ+hYrCHuq9ADm3O81UdH3roAA=";
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
