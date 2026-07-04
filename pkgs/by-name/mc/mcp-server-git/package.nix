{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-server-git";
  version = "2026.6.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = finalAttrs.version;
    hash = "sha256-n8l4E6S4d19GQnKWO1y2De1SuHa/R8UGlb/GMR4dbMw=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/git/";

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    click
    gitpython
    mcp
    pydantic
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mcp_server_git" ];

  meta = {
    changelog = "https://github.com/modelcontextprotocol/servers/releases/tag/${finalAttrs.version}";
    description = "Model Context Protocol server providing tools to read, search, and manipulate Git repositories programmatically via LLMs";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mcp-server-git";
    platforms = lib.platforms.all;
  };
})
