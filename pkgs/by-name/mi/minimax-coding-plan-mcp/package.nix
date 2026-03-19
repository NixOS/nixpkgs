{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "minimax-coding-plan-mcp";
  version = "0-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "MiniMax-AI";
    repo = "MiniMax-Coding-Plan-MCP";
    rev = "fbac3b3e56922a1249e00eebe07d9ee68f4768dc";
    hash = "sha256-pxXeakBfn2FYAiznuJyBy58FkoV/Sx1zSYaSFDZUJX0=";
  };

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    mcp
    python-dotenv
    requests
  ];

  pythonImportsCheck = [ "minimax_mcp" ];

  meta = {
    description = "MiniMax MCP server for coding-plan users with web search and image understanding";
    homepage = "https://github.com/MiniMax-AI/MiniMax-Coding-Plan-MCP";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ superherointj ];
    mainProgram = "minimax-coding-plan-mcp";
  };
})
