{
  lib,
  python3Packages,
  fetchFromGitHub,
  pyright,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "serena";
  version = "0.1.4";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "oraios";
    repo = "serena";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oj5iaQZa9gKjjaqq/DDT0j5UqVbPjWEztSuaOH24chI=";
  };

  postPatch = ''
    # Remove the deprecated dotenv stub package (serena uses python-dotenv)
    substituteInPlace pyproject.toml \
      --replace-fail '"dotenv>=0.9.9",' ""

    # Remove pyright from Python dependencies and make it available at runtime
    # instead
    substituteInPlace pyproject.toml \
      --replace-fail '"pyright>=1.1.396,<2",' ""
  '';

  build-system = [ python3Packages.hatchling ];

  pythonRelaxDeps = [
    "mcp"
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ pyright ]}"
  ];

  dependencies = with python3Packages; [
    anthropic
    docstring-parser
    flask
    jinja2
    joblib
    mcp
    overrides
    pathspec
    psutil
    pydantic
    python-dotenv
    pyyaml
    requests
    ruamel-yaml
    sensai-utils
    tiktoken
    tqdm
    types-pyyaml
  ];

  optional-dependencies = with python3Packages; {
    google = [ google-genai ];
  };

  pythonImportsCheck = [ "serena" ];

  meta = {
    description = "Coding agent toolkit providing semantic code operations for LLMs via MCP";
    homepage = "https://github.com/oraios/serena";
    changelog = "https://github.com/oraios/serena/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpds ];
  };
})
