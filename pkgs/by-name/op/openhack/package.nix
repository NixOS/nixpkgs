{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "openhack";
  version = "0.2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "openhackai";
    repo = "openhack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GY95oijrD/yTZI8DpbRVkCXRhMIw5Zsukt22tnglCVc=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    aiohttp
    httpx
    openai
    playwright
    prompt-toolkit
    pydantic
    pydantic-settings
    pygments
    rich
    tree-sitter
    tree-sitter-javascript
    tree-sitter-python
    tree-sitter-typescript
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  pythonImportsCheck = [ "openhack" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open Source Agentic Security Scanner";
    homepage = "https://github.com/openhackai/openhack";
    changelog = "https://github.com/openhackai/openhack/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "openhack";
  };
})
