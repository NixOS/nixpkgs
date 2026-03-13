{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,

  # tests
  uv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mistral-vibe";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-vibe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aXRceZAW4XUAXfD8HzGnS6qkFAj6VoTwVepZJmvf48Q=";
  };

  build-system = with python3Packages; [
    editables
    hatch-vcs
    hatchling
  ];

  pythonRelaxDeps = [
    "agent-client-protocol"
    "cryptography"
    "gitpython"
    "mistralai"
    "pydantic-settings"
    "zstandard"
  ];
  dependencies = with python3Packages; [
    agent-client-protocol
    anyio
    cachetools
    cryptography
    gitpython
    giturlparse
    google-auth
    httpx
    keyring
    mcp
    markdownify
    mistralai
    packaging
    pexpect
    pydantic
    pydantic-settings
    pyperclip
    python-dotenv
    pyyaml
    requests
    rich
    textual
    textual-speedups
    tomli-w
    tree-sitter
    tree-sitter-bash
    watchfiles
    zstandard
  ];

  pythonImportsCheck = [ "vibe" ];

  nativeCheckInputs = [
    python3Packages.pytest-asyncio
    python3Packages.pytest-textual-snapshot
    python3Packages.pytest-xdist
    python3Packages.pytestCheckHook
    python3Packages.respx
    uv
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError
    "test_rebuilds_index_when_mass_change_threshold_is_exceeded"
    "test_updates_index_incrementally_by_default"
    "test_updates_index_on_file_creation"
    "test_updates_index_on_file_deletion"
    "test_updates_index_on_file_rename"
    "test_updates_index_on_folder_rename"
    "test_watcher_toggle_flow_off_on_off"
  ];

  disabledTestPaths = [
    # All snapshot tests fail with AssertionError
    "tests/snapshots/"

    # Try to invoke `uv run vibe`
    "tests/e2e/"

    # ACP tests require network access
    "tests/acp/test_acp.py"
  ];

  meta = {
    description = "Minimal CLI coding agent by Mistral";
    homepage = "https://github.com/mistralai/mistral-vibe";
    changelog = "https://github.com/mistralai/mistral-vibe/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      shikanime
      mana-byte
    ];
    mainProgram = "vibe";
  };
})
