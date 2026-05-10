{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-nixos";
  version = "2.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "utensils";
    repo = "mcp-nixos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mWq9nnL4IGhUFkXJr8+t6BresOTDFS1caG8NuFqjrJg=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    beautifulsoup4
    fastmcp
    mcp
    requests
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
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
