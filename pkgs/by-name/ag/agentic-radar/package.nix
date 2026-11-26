{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "agentic-radar";
  version = "0.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "splx-ai";
    repo = "agentic-radar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YRdTWQdG3CwCl76t1FkuvP7w1nKhcWFBqx6aErPitog=";
  };

  pythonRelaxDeps = [
    "websockets"
    "importlib-resources"
    "openai"
    "rich"
  ];

  pythonRemoveDeps = [
    "dotenv"
    "typer-slim"
  ];

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    # crewai-tools  # Optional dependency
    importlib-resources
    jinja2
    openai
    openai-agents
    pydantic
    python-dotenv
    pyyaml
    rich
    typer
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "agentic_radar" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Security scanner for LLM agentic workflows";
    homepage = "https://github.com/splx-ai/agentic-radar";
    changelog = "https://github.com/splx-ai/agentic-radar/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "agentic-radar";
  };
})
