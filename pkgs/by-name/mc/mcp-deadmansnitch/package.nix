{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "mcp-deadmansnitch";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jamesbrink";
    repo = "mcp-deadmansnitch";
    tag = "v${version}";
    hash = "sha256-BWJ7N63uIZ72/ZGHscz8AuTHPrc5RBKuAIjWmbRvQLQ=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    fastmcp
    httpx
    python-dotenv
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
    pytest-cov
  ];

  disabledTestPaths = [
    # Requires DEADMANSNITCH_API_KEY
    "tests/test_integration.py"
  ];

  pythonImportsCheck = [ "mcp_deadmansnitch" ];

  meta = {
    description = "MCP server for Dead Man's Snitch cron job monitoring";
    homepage = "https://github.com/jamesbrink/mcp-deadmansnitch";
    changelog = "https://github.com/jamesbrink/mcp-deadmansnitch/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamesbrink ];
    mainProgram = "mcp-deadmansnitch";
  };
}
