{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-server-fetch";
  version = "2026.1.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    rev = "f4244583a6af9425633e433a3eec000d23f4e011";
    hash = "sha256-bHknioQu8i5RcFlBBdXUQjsV4WN1IScnwohGRxXgGDk=";
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
