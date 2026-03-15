{
  lib,
  fetchFromGitHub,
  gitUpdater,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "markitdown-mcp";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "markitdown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sqWfft/yaI/0FavhIbAHqltgVfTNk0GJk/phyvdn7Ck=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/markitdown-mcp";

  build-system = [
    python3Packages.hatchling
  ];

  pythonRelaxDeps = [
    "mcp"
  ];

  dependencies = with python3Packages; [
    markitdown
    mcp
  ];

  pythonImportsCheck = [
    "markitdown_mcp"
  ];

  passthru.updateScripts = gitUpdater { };

  meta = {
    description = "MCP server for the markitdown library";
    homepage = "https://github.com/microsoft/markitdown/tree/main/packages/markitdown-mcp";
    changelog = "https://github.com/microsoft/markitdown/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = python3Packages.markitdown.meta.maintainers;
    mainProgram = "markitdown-mcp";
    platforms = lib.platforms.all;
  };
})
