{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-nixos";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "utensils";
    repo = "mcp-nixos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/3/MUCjUu4iQOEmgda61ztO2d6e/HPpjsF9Z7hTWYMc=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    beautifulsoup4
    fastmcp
    mcp
    requests
  ];

  nativeCheckInputs = with python3Packages; [
    anthropic
    pytestCheckHook
    pytest-asyncio
    pytest-cov
    python-dotenv
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_integration.py"
  ];

  disabledTests = [
    # Requires network access
    "test_valid_channel"
  ];

  pythonImportsCheck = [ "mcp_nixos" ];

  meta = {
    description = "MCP server for NixOS";
    homepage = "https://github.com/utensils/mcp-nixos";
    changelog = "https://github.com/utensils/mcp-nixos/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
    mainProgram = "mcp-nixos";
  };
})
