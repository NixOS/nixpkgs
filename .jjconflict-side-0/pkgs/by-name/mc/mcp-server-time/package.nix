{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-server-time";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gzT45m4S/S7sighNwYw4I01jiLsUrGh+9H9p0neaQDE=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/time/";

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    mcp
    pydantic
    tzdata
    tzlocal
  ];

  nativeCheckInputs = with python3Packages; [
    freezegun
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # AssertionError: the console script is not installed in this venv
    "test_console_script_boots_over_stdio"
    "test_console_script_rejects_an_invalid_local_timezone"
  ];

  pythonImportsCheck = [ "mcp_server_time" ];

  meta = {
    changelog = "https://github.com/modelcontextprotocol/servers/releases/tag/${finalAttrs.version}";
    description = "Model Context Protocol server providing tools for time queries and timezone conversions for LLMs";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mcp-server-time";
    platforms = lib.platforms.all;
  };
})
