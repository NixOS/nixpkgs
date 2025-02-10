{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "oterm";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ggozad";
    repo = "oterm";
    tag = version;
    hash = "sha256-JE9WgAtCDksfVq17LIDdfvjR9IW02vkH2JhY7eLOgF0=";
  };

  pythonRelaxDeps = [
    "aiosqlite"
    "httpx"
    "ollama"
    "packaging"
    "pillow"
    "textual"
    "typer"
  ];

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    aiohttp
    aiosql
    aiosqlite
    httpx
    mcp
    ollama
    packaging
    pillow
    pyperclip
    python-dotenv
    rich-pixels
    textual
    textualeffects
    typer
  ];

  pythonImportsCheck = [ "oterm" ];

  # Tests require a HTTP connection to ollama
  doCheck = false;

  meta = {
    description = "Text-based terminal client for Ollama";
    homepage = "https://github.com/ggozad/oterm";
    changelog = "https://github.com/ggozad/oterm/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
    mainProgram = "oterm";
  };
}
