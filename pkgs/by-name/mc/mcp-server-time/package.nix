{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-server-time";
  version = "2026.6.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = finalAttrs.version;
    hash = "sha256-n8l4E6S4d19GQnKWO1y2De1SuHa/R8UGlb/GMR4dbMw=";
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
