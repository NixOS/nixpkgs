{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mcp-nixos";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "utensils";
    repo = "mcp-nixos";
    tag = "v${version}";
    hash = "sha256-rnpIDY/sy/uV+1dsW+MrFwAFE/RHg5K/6aa5k7Yt1Dc=";
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
    changelog = "https://github.com/utensils/mcp-nixos/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
    mainProgram = "mcp-nixos";
  };
}
