{
  lib,
  fetchFromGitHub,
  gitUpdater,
  python3Packages,
}:

let
  pythonPackages = python3Packages.overrideScope (
    self: super: {
      mcp = self.mcp_2;
    }
  );
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "markitdown-mcp";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "markitdown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nOzhvIqyq5iV2pKeHqStKELFLRnTRF7+pbxHaV0XZ4s=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/markitdown-mcp";

  build-system = [
    pythonPackages.hatchling
  ];

  dependencies =
    with pythonPackages;
    [
      markitdown
      mcp
      requests
    ]
    ++ markitdown.optional-dependencies.all;

  pythonImportsCheck = [
    "markitdown_mcp"
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "MCP server for the markitdown library";
    homepage = "https://github.com/microsoft/markitdown/tree/main/packages/markitdown-mcp";
    changelog = "https://github.com/microsoft/markitdown/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = pythonPackages.markitdown.meta.maintainers;
    mainProgram = "markitdown-mcp";
    platforms = lib.platforms.all;
  };
})
