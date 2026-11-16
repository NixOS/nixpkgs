{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-searxng";
  version = "2.10.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ihor-sokoliuk";
    repo = "mcp-searxng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xe2UNUGAtvuDwvEE7hkmTNfQ4/MUoGkkIHM1gRdtdYg=";
  };

  npmDepsHash = "sha256-4K+IYkSaRjNUzAr+vJ0RlvkytwMc5D0Uji/RTYE3zwA=";

  meta = {
    description = "Private web search for AI assistants via SearXNG — supports Claude, Cursor, and any MCP client";
    homepage = "https://github.com/ihor-sokoliuk/mcp-searxng";
    changelog = "https://github.com/ihor-sokoliuk/mcp-searxng/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "mcp-searxng";
  };
})
