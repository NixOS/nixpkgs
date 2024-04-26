{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "oterm";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ggozad";
    repo = "oterm";
    rev = "refs/tags/${version}";
    hash = "sha256-I/0U4lYqYZ6QCmWbDYhSOTCQ8o09W2cdd8kW7iN9iHU=";
  };

  pythonRelaxDeps = [
    "aiosqlite"
    "pillow"
    "httpx"
    "packaging"
  ];

  propagatedBuildInputs = with python3Packages; [
    ollama
    textual
    typer
    python-dotenv
    httpx
    aiosql
    aiosqlite
    pyperclip
    packaging
    rich-pixels
    pillow
    aiohttp
  ];

  nativeBuildInputs = with python3Packages; [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonImportsCheck = [
    "oterm"
  ];

  # Tests require a HTTP connection to ollama
  doCheck = false;

  meta = {
    changelog = "https://github.com/ggozad/oterm/releases/tag/${version}";
    description = "A text-based terminal client for Ollama";
    homepage = "https://github.com/ggozad/oterm";
    license = lib.licenses.mit;
    mainProgram = "oterm";
    maintainers = with lib.maintainers; [ suhr ];
  };
}
