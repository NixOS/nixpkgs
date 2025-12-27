{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "snowflake-cli";
  version = "3.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-cli";
    tag = "v${version}";
    hash = "sha256-2cZ9tRcQ/sWHkkSXMZ9pXP4zM3OsNbKr2kR/Ob/F9Hk=";
  };

  build-system = with python3Packages; [
    hatchling
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
    # Upstream code is using `pip` as a python module in some Snowpark-related
    # plugins, when there is a need to build a dependency closure from packages
    # on PyPi.
    # Example:
    # https://github.com/snowflakedb/snowflake-cli/blob/1caafee58fd1a8ae6d8788c33b86f637c263a29e/src/snowflake/cli/_plugins/snowpark/package_utils.py#L223
    # It's invoking `pip` as `python -m pip`, so `pip` needs to be in
    # dependencies.
    pip
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

  ]
  # Looks like these tests do not work with the sandbox on Darwin
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_allow_comments_at_source_url"
    "test_mixed_recursion"
    "test_parse_source_invalid_url"
    "test_parse_source_url"
    "test_recursion_from_url"
    "test_source_missing_url"
  ];

  disabledTestPaths = [
    "tests/app/test_version_check.py"
    "tests/nativeapp/test_sf_sql_facade.py"
    # Tests don't work as of v3.12.0
    # They either break sandbox by requiring network access or have outdated snapshots
    "tests/api/commands/test_snow_typer.py::test_enabled_command_is_visible"
    "tests/auth/test_auth.py::test_rotate" # snapshot
    "tests/auth/test_auth.py::test_rotate_only_public_key_set" # snapshot
    "tests/auth/test_auth.py::test_rotate_other_public_key_set_options[KEY-KEY]" # snapshot
    "tests/auth/test_auth.py::test_rotate_other_public_key_set_options[None-KEY]" # snapshot
    "tests/auth/test_auth.py::test_rotate_with_password" # snapshot
    "tests/auth/test_auth.py::test_setup" # snapshot
    "tests/auth/test_auth.py::test_setup_connection_already_exists" # snapshot
    "tests/auth/test_auth.py::test_setup_error_if_any_public_key_is_set" # snapshot
    "tests/auth/test_auth.py::test_setup_overwrite_connection" # snapshot
    "tests/auth/test_auth.py::test_setup_with_password" # snapshot
    "tests/stage/test_stage.py::test_stage_create_encryption"
    "tests/test_connection.py::test_connection_can_be_added_with_existing_paths_in_arguments"
    "tests/test_connection.py::test_connection_can_be_added_with_existing_paths_in_prompt[10]"
    "tests/test_connection.py::test_connection_can_be_added_with_existing_paths_in_prompt[9]"
    "tests/test_connection.py::test_connection_remove_all"
    "tests/test_connection.py::test_connection_remove_one"
    "tests/test_connection.py::test_connection_remove_some" # snapshot
    "tests/test_connection.py::test_fails_if_existing_connection"
    "tests/test_connection.py::test_file_paths_have_to_exist_when_given_in_arguments[-k]" # sandbox
    "tests/test_connection.py::test_file_paths_have_to_exist_when_given_in_arguments[-t]"
    "tests/test_connection.py::test_file_paths_have_to_exist_when_given_in_prompt[10]"
    "tests/test_connection.py::test_generate_jwt_with_passphrase[]" # snapshot
    "tests/test_connection.py::test_if_password_callback_is_called_only_once_from_arguments"
    "tests/test_connection.py::test_if_password_callback_is_called_only_once_from_prompt"
    "tests/test_connection.py::test_if_whitespaces_are_stripped_from_connection_name"
    "tests/test_connection.py::test_new_connection_add_prompt_handles_default_values" # snapshot
    "tests/test_connection.py::test_new_connection_add_prompt_handles_prompt_override"
    "tests/test_connection.py::test_new_connection_can_be_added"
    "tests/test_connection.py::test_new_connection_is_added_to_connections_toml"
    "tests/test_connection.py::test_new_connection_with_jwt_auth"
    "tests/test_connection.py::test_port_has_cannot_be_float"
    "tests/test_connection.py::test_port_has_cannot_be_string"
    "tests/test_connection.py::test_second_connection_not_update_default_connection"
    "tests/test_connection.py::test_session_and_master_tokens"
    "tests/test_connection.py::test_token_file_path_tokens"
    "tests/test_docs_generation_output.py::test_flags_have_default_values" # snapshot
    "tests/test_init.py::test_init_default_values"
    "tests/test_init.py::test_rename_project"
    "tests/test_init.py::test_variables_flags"
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
    changelog = "https://github.com/snowflakedb/snowflake-cli/blob/${src.tag}/RELEASE-NOTES.md";
    homepage = "https://docs.snowflake.com/en/developer-guide/snowflake-cli-v2/index";
    description = "Command-line tool explicitly designed for developer-centric workloads in addition to SQL operations";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vtimofeenko ];
    mainProgram = "snow";
  };
}
