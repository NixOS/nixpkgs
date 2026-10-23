{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "notion-mcp-server";
  version = "2.5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "makenotion";
    repo = "notion-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ioZjtjf00/N3SRV8WEG7NuDVjrZXAcNr8OnUA/PkUpY=";
  };

  npmDepsHash = "sha256-VPmRy8uaKeiSTAvwDceupcHC7tIS7p3Xi8vnvQcE9SM=";

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    npm test
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official MCP server for the Notion API";
    homepage = "https://github.com/makenotion/notion-mcp-server";
    changelog = "https://github.com/makenotion/notion-mcp-server/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ slopinger ];
    mainProgram = "notion-mcp-server";
  };
})
