{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-proxy";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "sparfenyuk";
    repo = "mcp-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rurNHP5TprhFUrg+0E6FnNxhCqQv2xtkfhUrGUdGod0=";
  };

  pyproject = true;

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    httpx-auth
    mcp
    uvicorn
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

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
})
