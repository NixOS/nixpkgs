{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "mcp-proxy";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "sparfenyuk";
    repo = "mcp-proxy";
    tag = "v${version}";
    hash = "sha256-3hNpUOWbyOUjLcvfcMzj4+xHyUl7k1ZSy8muWHvSEvM=";
  };

  pyproject = true;

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    uvicorn
    mcp
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # AssertionError: expected call not found.
    # Expected: mock(PromptReference(type='ref/prompt', name='name'), CompletionArgument(name='name', value='value'))
    #   Actual: mock(PromptReference(type='ref/prompt', name='name'), CompletionArgument(name='name', value='value'), None)
    "test_call_tool[server-AsyncMock]"
    "test_call_tool[proxy-AsyncMock]"
    "test_complete[server-AsyncMock]"
    "test_complete[proxy-AsyncMock]"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "MCP server which proxies other MCP servers from stdio to SSE or from SSE to stdio";
    homepage = "https://github.com/sparfenyuk/mcp-proxy";
    mainProgram = "mcp-proxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keyruu ];
  };
}
