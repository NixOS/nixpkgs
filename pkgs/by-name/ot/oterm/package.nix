{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "oterm";
  version = "0.14.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ggozad";
    repo = "oterm";
    tag = finalAttrs.version;
    hash = "sha256-f8UUWQtn+lG0mzO7i6LWDoNwGBLFbIbGdqAptNgoek4=";
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
    "fastmcp"
  ];

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    aiohttp
    aiosql
    aiosqlite
    fastmcp
    httpx
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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Text-based terminal client for Ollama";
    homepage = "https://github.com/ggozad/oterm";
    changelog = "https://github.com/ggozad/oterm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
    mainProgram = "oterm";
  };
})
