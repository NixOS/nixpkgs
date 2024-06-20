{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "oterm";
  version = "0.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ggozad";
    repo = "oterm";
    rev = "refs/tags/${version}";
    hash = "sha256-UOZxktgpuTxkE1+DVnd5T1Fye+2SS2hUDmWtCaGEol0=";
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

  build-system = with python3Packages; [ poetry-core ];

  nativeBuildInputs = with python3Packages; [ pythonRelaxDepsHook ];

  dependencies = with python3Packages; [
    aiohttp
    aiosql
    aiosqlite
    httpx
    ollama
    packaging
    pillow
    pyperclip
    python-dotenv
    rich-pixels
    textual
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
    maintainers = with lib.maintainers; [ suhr ];
    mainProgram = "oterm";
  };
}
