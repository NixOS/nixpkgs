{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "oterm";
  version = "0.1.18";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "ggozad";
    repo = "oterm";
    rev = "refs/tags/${version}";
    hash = "sha256-hog0oEiZMxM3lM3xFZ+c15OTOwGXZ97FmG4PpyA94Ys=";
  };
  propagatedBuildInputs = with python3Packages; [
    textual
    typer
    python-dotenv
    httpx
    aiosql
    aiosqlite
    pyperclip
    packaging
    rich-pixels
  ];
  nativeBuildInputs = with python3Packages; [ poetry-core ];

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
