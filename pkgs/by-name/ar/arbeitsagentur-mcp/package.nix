{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "arbeitsagentur-mcp";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slopinger";
    repo = "arbeitsagentur-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G4878oLb9dCQc1jbYtCnsC0HUV+0hI99pkNEX9QZcZ4=";
  };

  build-system = with python3Packages; [ uv-build ];

  dependencies = with python3Packages; [
    httpx
    mcp
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "arbeitsagentur_mcp" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MCP server for customers of the German Federal Employment Agency (Bundesagentur für Arbeit)";
    homepage = "https://github.com/slopinger/arbeitsagentur-mcp";
    changelog = "https://github.com/slopinger/arbeitsagentur-mcp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ slopinger ];
    mainProgram = "arbeitsagentur-mcp";
  };
})
