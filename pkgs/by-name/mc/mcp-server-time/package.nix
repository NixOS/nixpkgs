{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-server-time";
  version = "2026.1.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = finalAttrs.version;
    hash = "sha256-uULXUEHFZpYm/fmF6PkOFCxS+B+0q3dMveLG+3JHrhk=";
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
    mainProgram = "mcp-server-git";
    platforms = lib.platforms.all;
  };
})
