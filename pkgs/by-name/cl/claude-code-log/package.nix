{
  fetchFromGitHub,
  lib,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "claude-code-log";
  version = "1.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "daaain";
    repo = "claude-code-log";
    tag = finalAttrs.version;
    hash = "sha256-ZKf3y9AI3xiez2zIWWEmqJnJgLrPy+Dx52Bi8ryhPiY=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    click
    dateparser
    gitpython
    jinja2
    mistune
    packaging
    pydantic
    pygments
    textual
    toml
  ];

  nativeCheckInputs = [ versionCheckHook ];

  pythonImportsCheck = [
    "claude_code_log.cli" # Entrypoint.
    "claude_code_log.tui" # Not eagerly imported by the CLI module.
  ];

  meta = {
    description = "Convert Claude Code transcript JSONL files into HTML, Markdown, or JSON";
    homepage = "https://github.com/daaain/claude-code-log";
    changelog = "https://github.com/daaain/claude-code-log/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "claude-code-log";
    maintainers = with lib.maintainers; [ samestep ];
  };
})
