{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "duckduckgo-mcp-server";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nickclyde";
    repo = "duckduckgo-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wI6Q4lBZYzU4VORLwGZowv8D5UfhKaMeqBIQ7u6eRxc=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies =
    with python3Packages;
    [
      beautifulsoup4
      httpcore
      httpx
      mcp
    ]
    ++ mcp.optional-dependencies.cli;

  optional-dependencies = with python3Packages; {
    browser = [ curl-cffi ];
  };

  nativeCheckInputs = with python3Packages; [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "duckduckgo_mcp_server" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MCP server for web search and page fetching via DuckDuckGo";
    homepage = "https://github.com/nickclyde/duckduckgo-mcp-server";
    changelog = "https://github.com/nickclyde/duckduckgo-mcp-server/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ slopinger ];
    mainProgram = "duckduckgo-mcp-server";
  };
})
