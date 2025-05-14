{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "oterm";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ggozad";
    repo = "oterm";
    tag = version;
    hash = "sha256-b/+siNzmM6RUJ3jv/2dNJJFueejChKde0D5r8J0lTqM=";
  };

  pythonRelaxDeps = [
    "aiosql"
    "aiosqlite"
    "httpx"
    "ollama"
    "packaging"
    "pillow"
    "pydantic"
    "textual"
    "typer"
  ];

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    aiohttp
    aiosql
    aiosqlite
    httpx
    jinja2
    mcp
    ollama
    packaging
    pillow
    pyperclip
    python-dotenv
    rich-pixels
    textual
    textual-image
    textualeffects
    typer
  ];

  pythonImportsCheck = [ "oterm" ];

  # Python tests require a HTTP connection to ollama

  # Fails on darwin with: PermissionError: [Errno 1] Operation not permitted: '/var/empty/Library'
  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Text-based terminal client for Ollama";
    homepage = "https://github.com/ggozad/oterm";
    changelog = "https://github.com/ggozad/oterm/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
    mainProgram = "oterm";
  };
}
