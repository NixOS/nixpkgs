{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  writableTmpDirAsHomeHook,
}:

let
  # RuntimeError: There is no active click context
  # Upstream pins click==8.1.8 and typer==0.17.3, see https://github.com/snowflakedb/snowflake-cli/issues/3175
  click_8_1 = python3Packages.click.overridePythonAttrs (_old: rec {
    version = "8.1.8";
    src = python3Packages.click.src.override {
      tag = version;
      hash = "sha256-pAAqf8jZbDfVZUoltwIFpov/1ys6HSYMyw3WV2qcE/M=";
    };
  });
  typer_0_17 = python3Packages.typer.overridePythonAttrs (_old: rec {
    version = "0.17.3";
    src = python3Packages.typer.src.override {
      tag = version;
      hash = "sha256-ir4RL1Cdq0ENr0ojiJvrdFaZHb4bF8q4rLcKeowliR0=";
    };
    # Patches tests that don't exist in 0.17.3
    postPatch = null;
    dependencies = with python3Packages; [
      click_8_1
      rich
      shellingham
      typing-extensions
    ];
    doCheck = false;
  });
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "snowflake-cli";
  version = "3.33.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9E/TYnCC3+1hsZvkN4ceL+N/xmvJoWv3OJJc+G3tPPM=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  dependencies = with python3Packages; [
    configobj
    gitpython
    id
    jinja2
    pip # required by some plugins
    keyring # snowflake-connector-python[secure-local-storage]
    pluggy
    prompt-toolkit
    protobuf
    pydantic
    python-dotenv
    pyyaml
    requests
    requirements-parser
    rich
    setuptools
    snowflake-connector-python
    snowflake-core
    tomlkit
    typer_0_17
    urllib3
    websocket-client
  ];

  pythonRemoveDeps = [ "snowflake-snowpark-python" ];

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
    # Upstream sets `--maxfail=10`, hiding most failures
    "--maxfail=0"
  ];

  disabledTests = [
    # Snapshot has TOML parse error column from the pinned tomlkit version
    "test_corrupted_config_raises_human_friendly_error"
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

    # Template values no longer bypass validation with pydantic 2.13
    "test_updatable_model_with_plain_validator"
    "test_updatable_model_with_sub_classes_and_template_values_and_custom_validator_in_parent"
    "test_updatable_model_with_sub_classes_and_template_values_and_custom_validator_in_child"
    "test_updatable_model_with_int_and_templates"
    "test_updatable_model_with_validators"
    "test_updatable_model_with_bool_and_templates"
    "test_updatable_model_with_sub_classes_and_template_values"

    # FileNotFoundError: [Errno 2] No such file or directory: '/build/tmp.../.snowflake/connections.toml'
    "test_new_connection_with_jwt_auth"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Long macOS tmpdir path gets wrapped mid-assertion
    "test_output_file_missing_parent_raises"
  ];

  disabledTestPaths = [
    # Version is a placeholder without .git metadata
    "tests/app/test_version_check.py"

    # snowflake-snowpark isn't packaged
    "tests/snowpark/"
    "tests/feature"
    "tests/stage/test_stage.py::test_execute_with_variables"
    "tests/stage/test_stage.py::test_execute_continue_on_error"
    "tests/stage/test_stage.py::test_execute_stop_on_error"

    # Upstream release tooling
    "tests/packaging"
    "tests/test_assemble_channel.py"
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
