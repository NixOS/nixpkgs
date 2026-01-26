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

python3Packages.buildPythonApplication rec {
  pname = "clickable";
  version = "8.7.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "clickable";
    repo = "clickable";
    rev = "v${version}";
    hash = "sha256-W6NPZ5uP7wGjgyA+Nv2vpmshKWny2CCSrn/Gaoi7Pr4=";
  };

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

  disabledTests =
    # Tests require running docker daemon
    [
      "test_cpp_plugin"
      "test_godot_plugin"
      "test_html"
      "test_python"
      "test_qml_only"
      "test_rust"
    ]
    # Tests do not work on non-amd64 platforms
    ++ lib.optionals (!stdenv.hostPlatform.isx86_64) [
      # hardcode amd64
      "test_arch"
      "test_restricted_arch"

      # no -ide images on arm64
      # https://gitlab.com/clickable/clickable/-/issues/478
      "test_command_overrided"
      "test_init_cmake_project"
      "test_init_cmake_project_exe_as_var"
      "test_init_cmake_project_no_exe"
      "test_init_cmake_project_no_to_prompt"
      "test_initialize_qtcreator_conf"
      "test_project_pre_configured"
      "test_recurse_replace"
    ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Build system for Ubuntu Touch apps";
    mainProgram = "clickable";
    homepage = "https://clickable-ut.dev";
    changelog = "https://clickable-ut.dev/en/latest/changelog.html#changes-in-v${
      lib.strings.replaceStrings [ "." ] [ "-" ] version
    }";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ilyakooo0 ];
    teams = [ lib.teams.lomiri ];
  };
}
