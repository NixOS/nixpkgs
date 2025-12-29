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

python3Packages.buildPythonApplication rec {
  pname = "mistral-vibe";
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-vibe";
    tag = "v${version}";
    hash = "sha256-nW7pRSyv+t/7yatx84PMgxsHRTfRqqpy6rz+dQfLluU=";
  };

  build-system = with python3Packages; [
    editables
    hatch-vcs
    hatchling
  ];

  pythonRelaxDeps = [
    "agent-client-protocol"
    "mistralai"
    "pydantic"
    "pydantic-settings"
    "watchfiles"
  ];
  dependencies = with python3Packages; [
    agent-client-protocol
    aiofiles
    httpx
    mcp
    mistralai
    packaging
    pexpect
    pydantic
    pydantic-settings
    pyperclip
    python-dotenv
    pyyaml
    rich
    textual
    textual-speedups
    tomli-w
    watchfiles
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
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];
  pytestFlags = [ "tests/cli/test_clipboard.py" ];

  disabledTests = [
    # AssertionError: assert '/nix/store/rlq03x4cwf8zn73hxaxnx0zn5q9kifls-bash-5.3p3/bin/sh:
    # warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8): No such file or directory\n' == ''
    "test_decodes_non_utf8_bytes"
    "test_runs_echo_successfully"
    "test_truncates_output_to_max_bytes"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert 3 == 4
    "test_get_copy_fns_with_wl_copy"
    "test_get_copy_fns_with_both_system_tools"
    "test_get_copy_fns_with_xclip"
  ];

  disabledTestPaths = [
    # All snapshot tests fail with AssertionError
    "tests/snapshots/"

    # ACP tests require network access
    "tests/acp/test_acp.py"
  ];

  meta = {
    description = "Minimal CLI coding agent by Mistral";
    homepage = "https://github.com/mistralai/mistral-vibe";
    changelog = "https://github.com/mistralai/mistral-vibe/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      shikanime
    ];
    mainProgram = "vibe";
  };
}
