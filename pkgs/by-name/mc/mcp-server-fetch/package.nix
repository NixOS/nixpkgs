{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-server-fetch";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L6t0QuJshn207uc3+n+IoDp7vPuY2YLcu6ku1rEgzHk=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/fetch/";

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    httpx
    markdownify
    mcp
    protego
    pydantic
    readabilipy
    requests
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "mcp_server_fetch" ];

  meta = {
    changelog = "https://github.com/modelcontextprotocol/servers/releases/tag/${finalAttrs.version}";
    description = "Model Context Protocol server providing tools to fetch and convert web content for usage by LLMs";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mcp-server-fetch";
    platforms = lib.platforms.all;
  };
})
