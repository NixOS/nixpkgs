{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "snowflake-cli";
  version = "3.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2cZ9tRcQ/sWHkkSXMZ9pXP4zM3OsNbKr2kR/Ob/F9Hk=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  patches = [
    ./generate-json-schema-kwargs.patch
  ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [
    click
    gitpython
    id
    jinja2
    pip # required by some plugins
    pluggy
    prompt-toolkit
    pydantic
    pyyaml
    requests
    requirements-parser
    rich
    setuptools
    snowflake-connector-python
    snowflake-core
    tomlkit
    typer
    urllib3
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

    # These snapshots seem to be broken
    "test_command_with_global_options"
    "test_command_without_any_options"
    "test_command_with_connection_options"

    # RuntimeError: There is no active click context
    "test_enhanced_exit_codes_context"

    # typer.exceptions.Abort
    "test_drop_application_cascade"
  ];

  disabledTestPaths = [
    "tests/app/test_version_check.py"
    "tests/nativeapp/test_sf_sql_facade.py"

    # Require network access
    "tests/test_connection.py"
    "tests/app/test_telemetry.py"

    # snowflake-snowpark isn't packaged
    "tests/snowpark/"

    # RuntimeError: There is no active click context
    "tests/api"
    "tests/app/test_telemetry.py"
    "tests/cortex/test_cortex_commands.py"
    "tests/dbt/test_dbt_commands.py"
    "tests/dcm/test_commands.py"
    "tests/git/test_git_commands.py"
    "tests/helpers/test_snowsql_env_vars.py"
    "tests/helpers/test_v1_to_v2.py"
    "tests/logs/test_logs.py"
    "tests/notebook/test_notebook_commands.py"
    "tests/object/test_object.py"
    "tests/output/test_silent_output.py"
    "tests/snowpark/"
    "tests/sql"
    "tests/stage/test_stage.py"
    "tests/streamlit"
    "tests/test_cli.py"
    "tests/test_command_registration.py"
    "tests/test_config.py"
    "tests/test_docs_generation_output.py"
    "tests/test_experimental_behaviour.py"
    "tests/test_init.py"
    "tests/test_main.py"
    "tests/test_oauth.py"
    "tests/test_snow_connector.py"
    "tests/test_workload_identity.py"
    "tests/workspace/test_manager.py"
    "tests/workspace/test_ws_dump.py"
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
    changelog = "https://github.com/snowflakedb/snowflake-cli/blob/${finalAttrs.src.tag}/RELEASE-NOTES.md";
    homepage = "https://docs.snowflake.com/en/developer-guide/snowflake-cli-v2/index";
    description = "Command-line tool explicitly designed for developer-centric workloads in addition to SQL operations";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sarahec
      vtimofeenko
    ];
    mainProgram = "snow";
  };
})
