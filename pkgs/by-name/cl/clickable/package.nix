{
  lib,
  fetchFromGitLab,
  gitUpdater,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "clickable";
  version = "8.2.0";

  src = fetchFromGitLab {
    owner = "clickable";
    repo = "clickable";
    rev = "v${version}";
    hash = "sha256-MFzpeiWeqJ0MG8ouwRkYXD1e6Nsxshmz1NSzCIBRjZ0=";
  };

  propagatedBuildInputs = with python3Packages; [
    cookiecutter
    requests
    pyyaml
    jsonschema
    argcomplete
    watchdog
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  disabledTests =
    [
      # Tests require docker
      "test_cpp_plugin"
      "test_html"
      "test_python"
      "test_qml_only"
      "test_rust"
      "test_review"
      "test_click_build"
      "test_no_device"
      "test_no_file_temp"
      "test_update"
      "test_lib_build"
      "test_clean"
      "test_temp_exception"
      "test_create_interactive"
      "test_create_non_interactive"
      "test_kill"
      "test_writable_image"
      "test_no_desktop_mode"
      "test_no_lock"
      "test_run_default_command"
      "test_run"
      "test_no_container_mode_log"
      "test_custom_mode_log"
      "test_skip_desktop_mode"
      "test_log"
      "test_custom_lock_file"
      "test_launch_custom"
      "test_launch"
      "test_devices"
      "test_install"
      "test_skip_container_mode"
      "test_godot_plugin"
    ]
    ++
    # There are no docker images available for the aarch64 architecutre
    # which are required for tests.
    lib.optionals stdenv.isAarch64 [
      "test_arch"
      "test_restricted_arch"
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
    maintainers = lib.teams.lomiri.members ++ (with lib.maintainers; [ ilyakooo0 ]);
  };
}
