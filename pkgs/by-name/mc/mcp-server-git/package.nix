{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-server-git";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sg1006mrZiVZTCiBjuYXqurWM5yDPxMKVOyOC+e7C4U=";
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
    pytest-asyncio
  ];

  disabledTests = [
    "test_console_script_nonexistent_repository_exits_with_one_line_error"
    "test_git_add_nonexistent_file_is_git_error"
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
