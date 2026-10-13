{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-searxng";
  version = "2.5.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ihor-sokoliuk";
    repo = "mcp-searxng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TqDj86FTOekTswNQkTkiC8Q/H46bz4iigr5GRlM9Tno=";
  };

  npmDepsHash = "sha256-WuN8xzG5uU1wZdMLdiT2GfUn1BeHTdtIkBc4x2kz81Q=";

  meta = {
    description = "Private web search for AI assistants via SearXNG — supports Claude, Cursor, and any MCP client";
    homepage = "https://github.com/ihor-sokoliuk/mcp-searxng";
    changelog = "https://github.com/ihor-sokoliuk/mcp-searxng/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "mcp-searxng";
  };
})
