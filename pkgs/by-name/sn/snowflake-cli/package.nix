{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "snowflake-cli";
  version = "3.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-cli";
    tag = "v${version}";
    hash = "sha256-dJc5q3vE1G6oJq9V4JSPaSyODxKDyhprIwBo39Nu/bA=";
  };

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
    pip
  ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [
    id
    jinja2
    pluggy
    pyyaml
    rich
    requests
    requirements-parser
    setuptools
    tomlkit
    typer
    urllib3
    gitpython
    pydantic
    prompt-toolkit
    snowflake-core
    snowflake-connector-python
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    syrupy
    coverage
    pytest-randomly
    pytest-factoryboy
    pytest-xdist
    pytest-httpserver
  ];

  pytestFlags = [
    "--snapshot-warn-unused"
  ];

  disabledTests = [
    "integration"
    "spcs"
    "loaded_modules"
    "integration_experimental"
    "test_snow_typer_help_sanitization" # Snapshot needs update?
    "test_help_message" # Snapshot needs update?
    "test_sql_help_if_no_query_file_or_stdin" # Snapshot needs update?
    "test_multiple_streamlit_raise_error_if_multiple_entities" # Snapshot needs update?
    "test_replace_and_not_exists_cannot_be_used_together" # Snapshot needs update?
    "test_format" # Snapshot needs update?
    "test_executing_command_sends_telemetry_usage_data" # Fails on mocked version
    "test_internal_application_data_is_sent_if_feature_flag_is_set"
    "test_if_bundling_dependencies_resolves_requirements" # impure?
    "test_silent_output_help" # Snapshot needs update? Diff between received and snapshot is the word 'TABLE' moving down a line
    "test_new_connection_can_be_added_as_default" # Snapshot needs update? Diff between received and snapshot is an empty line
  ];

  disabledTestPaths = [
    "tests/app/test_version_check.py"
    "tests/nativeapp/test_sf_sql_facade.py"
  ];

  pythonRelaxDeps = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''

    # Looks like the completion generation has some sort of a race
    # Occasionally one of the completion generations would fail with
    #
    # An unexpected exception occurred. Use --debug option to see the traceback. Exception message:
    # [Errno 17] File exists: '/build/tmp.W654FVhCPT/.config/snowflake/logs'
    #
    # This creates a fake config that prevents logging in the build sandbox.
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.config/snowflake
    cat <<EOF > $HOME/.config/snowflake/config.toml
    [cli.logs]
    save_logs = false
    EOF
    # snowcli checks the config permissions upon launch and exits with an error code if it's not 0600.
    chmod 0600 $HOME/.config/snowflake/config.toml

    # Typer tries to guess the current shell by default
    export _TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1

    installShellCompletion --cmd snow \
      --bash <($out/bin/snow --show-completion bash) \
      --fish <($out/bin/snow --show-completion fish) \
      --zsh <($out/bin/snow --show-completion zsh)
  '';

  meta = {
    changelog = "https://github.com/snowflakedb/snowflake-cli/blob/main/RELEASE-NOTES.md";
    homepage = "https://docs.snowflake.com/en/developer-guide/snowflake-cli-v2/index";
    description = "Command-line tool explicitly designed for developer-centric workloads in addition to SQL operations";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vtimofeenko ];
    mainProgram = "snow";
  };
}
