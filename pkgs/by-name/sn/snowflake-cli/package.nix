{
  lib,
  stdenv,
  darwin,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "snowflake-cli";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-QBYdzKKkakgwCD12bN7CerjfvMnxvt2cJ0NqTIjHkWw=";
  };

  build-system =
    (with python3Packages; [
      hatch-vcs
      hatchling
      pip
    ])
    ++ [ installShellFiles ];

  dependencies = with python3Packages; [
    jinja2
    pluggy
    pyyaml
    rich
    requests
    requirements-parser
    setuptools
    tomlkit
    # Typer needs to be >=0.12.5
    (typer.overridePythonAttrs (
      oldAttrs:
      let
        # Shadow the version for this override
        version = "0.12.5";
      in
      {
        inherit version;
        src = fetchPypi {
          pname = "typer";
          hash = "sha256-9ZLwib7cyOwbl0El1khRApw7GvFF8ErKZNaUEPDJtyI=";
          inherit version;
        };
        # Based on https://github.com/NixOS/nixpkgs/pull/281397 for poetry
        nativeCheckInputs = oldAttrs.nativeCheckInputs ++ lib.optionals stdenv.isDarwin [ darwin.ps ];
      }
    ))
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
  ];

  pytestFlagsArray = [
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

  postInstall = ''
    export HOME=$(mktemp -d)

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
    description = "Snowflake CLI is an open-source command-line tool explicitly designed for developer-centric workloads in addition to SQL operations.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vtimofeenko ];
    mainProgram = "snow";
  };
}
