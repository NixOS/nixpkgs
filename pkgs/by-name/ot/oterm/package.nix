{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "oterm";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ggozad";
    repo = "oterm";
    rev = "refs/tags/${version}";
    hash = "sha256-p0ns+8qmcyX4gcg0CfYdDMn1Ie0atVBuQbVQoDRQ9+c=";
  };

  pythonRelaxDeps = [
    "aiosql"
    "aiosqlite"
    "httpx"
    "packaging"
    "pillow"
  ];

  propagatedBuildInputs = with python3Packages; [
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

  nativeBuildInputs = with python3Packages; [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonImportsCheck = [
    "oterm"
  ];

  # Tests require a HTTP connection to ollama
  doCheck = false;

  meta = with lib; {
    description = "A text-based terminal client for Ollama";
    homepage = "https://github.com/ggozad/oterm";
    changelog = "https://github.com/ggozad/oterm/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ suhr ];
    mainProgram = "oterm";
  };
}
