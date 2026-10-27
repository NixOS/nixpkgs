{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-searxng";
  version = "2.7.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ihor-sokoliuk";
    repo = "mcp-searxng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H9AXMSGOGEcSyVTe7SoWwGNEKJzI+iDkslQwKSIk+oI=";
  };

  npmDepsHash = "sha256-IEeOBd32jlcb7mEveRNKuMKEqZs3eDpdxN4N567TmvU=";

  meta = {
    description = "Private web search for AI assistants via SearXNG — supports Claude, Cursor, and any MCP client";
    homepage = "https://github.com/ihor-sokoliuk/mcp-searxng";
    changelog = "https://github.com/ihor-sokoliuk/mcp-searxng/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "mcp-searxng";
  };
})
