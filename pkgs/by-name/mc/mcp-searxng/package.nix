{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-searxng";
  version = "2.4.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ihor-sokoliuk";
    repo = "mcp-searxng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1ZGo6150O8cn2b4pYLqPWs+l11L+SpeH+ATKE470Hwo=";
  };

  npmDepsHash = "sha256-21mw8/qUgLuAhF9KYZU7N+K4af7OBVwBHGqnr7p6lDE=";

  meta = {
    description = "Private web search for AI assistants via SearXNG — supports Claude, Cursor, and any MCP client";
    homepage = "https://github.com/ihor-sokoliuk/mcp-searxng";
    changelog = "https://github.com/ihor-sokoliuk/mcp-searxng/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "mcp-searxng";
  };
})
