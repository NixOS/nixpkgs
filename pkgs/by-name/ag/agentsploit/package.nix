{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "agentsploit";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agentsploit";
    repo = "agentsploit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xcAf5mJW5a+z5W5LGDKnUzb22YS0WEasX+y3CT65jZw=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    anthropic
    anyio
    fastapi
    httpx
    ics
    jinja2
    mcp
    openai
    pydantic
    pyyaml
    reportlab
    rich
    structlog
    typer
    uvicorn
  ];

  nativeCheckInputs = with python3Packages; [
    jsonschema
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    types-pyyaml
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  disabledTestPaths = [
    # Tests need network access
    "tests/unit/test_openai_adapter.py"
    "tests/integration/"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "version" ];

  pythonImportsCheck = [ "agentsploit" ];

  passthru.updateScript = nix-update-script { };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Offensive security framework for AI agents and MCP servers";
    homepage = "https://github.com/agentsploit/agentsploit";
    changelog = "https://github.com/agentsploit/agentsploit/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "agentsploit";
  };
})
