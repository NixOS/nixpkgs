{
  lib,
  python3Packages,
  fetchFromGitHub,
  ripgrep,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lean-lsp-mcp";
  version = "0.28.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "oOo0oOo";
    repo = "lean-lsp-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dpVWJ598in9S/GlYrnqZgz2T/5vQV1m/eI+lQBiD8w4=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    anyio
    leanclient
    mcp
    orjson
    certifi
  ];

  pythonRelaxDeps = [ "mcp" ];

  # lean_local_search and lean_verify spawn `rg`.
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ripgrep ])
  ];

  nativeCheckInputs = [
    ripgrep
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    pytest-asyncio
  ]);

  nativeInstallCheckInputs = [ versionCheckHook ];

  # The rest of tests/ builds a real Lean project through the test_project_path
  # fixture in tests/conftest.py; these three do not.
  enabledTestPaths = [
    "tests/unit"
    "tests/test_error_handling.py"
    "tests/test_transport_disconnect.py"
  ];

  disabledTests = [
    # These build loogle into the real user cache; they skip today only
    # because git and lake are absent from the sandbox.
    "TestLoogleInstall"
    "TestLoogleQuery"
    # Searches Mathlib but is missing the `skipif(not MATHLIB_DIR.is_dir())`
    # that its two siblings in tests/unit/test_search_utils.py carry. Drop this
    # once https://github.com/oOo0oOo/lean-lsp-mcp/pull/226 is in a release.
    "test_lean_search_integration_mathlib_prefix_limit"
  ];

  pythonImportsCheck = [ "lean_lsp_mcp" ];

  meta = {
    description = "MCP server for the Lean theorem prover via the Lean LSP";
    homepage = "https://github.com/oOo0oOo/lean-lsp-mcp";
    changelog = "https://github.com/oOo0oOo/lean-lsp-mcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ remix7531 ];
    mainProgram = "lean-lsp-mcp";
  };
})
