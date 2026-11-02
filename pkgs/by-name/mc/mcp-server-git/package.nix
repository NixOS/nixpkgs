{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-server-git";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gzT45m4S/S7sighNwYw4I01jiLsUrGh+9H9p0neaQDE=";
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
    # The test fails at:
    # script = shutil.which("mcp-server-git", path=str(Path(sys.executable).parent))
    "test_console_script_nonexistent_repository_exits_with_one_line_error"
    # The test fails at:
    # result = await call(None, "git_add", {"repo_path": str(root_of(repo)), "files": ["nope.txt"]})
    # When trying to assert the resulting test.
    # assert 'cmdline: git add -- nope.txt' in "Error executing tool git_add: Cmd('/nix/store/2wlays4ahsvdx02v84s3x91ri2623qbl-git-minimal-2.56.0/bin/git') failed du...91ri2623qbl-git-minimal-2.56.0/bin/git add -- nope.txt\n  stderr: 'fatal: pathspec 'nope.txt' did not match any files'"
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
