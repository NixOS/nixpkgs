{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "minimax-coding-plan-mcp";
  version = "0-unstable-2026-08-20";

  src = fetchFromGitHub {
    owner = "MiniMax-AI";
    repo = "MiniMax-Coding-Plan-MCP";
    rev = "5dbf3494d7dac35d154958e0c1dab03910b89bbd";
    hash = "sha256-bgaMFVqkbMXJug9q+Aj3MMt9tm/K/dZOT8rj1LtSnMg=";
  };

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    mcp_2
    python-dotenv
    requests
  ];

  pythonImportsCheck = [ "minimax_mcp" ];

  meta = {
    description = "MiniMax MCP server for coding-plan users with web search and image understanding";
    homepage = "https://github.com/MiniMax-AI/MiniMax-Coding-Plan-MCP";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "minimax-coding-plan-mcp";
  };
})
