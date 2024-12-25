{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "snowflake-cli";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-/n11GbrgFwjiAuwpFNJ3T96VDhdOy2x+hesgh4oPVbo=";
  };

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
    pip
  ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [
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
    snowflake-connector-python
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    syrupy
    coverage
    pytest-randomly
    pytest-factoryboy
    pytest-xdist
  ];

  pytestFlagsArray = [
    "-n"
    "$NIX_BUILD_CORES"
    "--snapshot-warn-unused" # Turn unused snapshots into a warning and not a failure
  ];

  disabledTests = [
    "integration"
    "spcs"
    "loaded_modules"
    "integration_experimental"
    "test_snow_typer_help_sanitization" # Snapshot needs update?
    "test_help_message" # Snapshot needs update?
    "test_executing_command_sends_telemetry_usage_data" # Fails on mocked version
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
