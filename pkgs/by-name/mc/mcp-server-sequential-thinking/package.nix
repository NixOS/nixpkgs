{
  lib,
  buildNpmPackage,
  typescript_5,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-server-sequential-thinking";
  version = "2026.8.18";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = finalAttrs.version;
    hash = "sha256-tRx/ZCyHnDP3BmK/xOgVKtjlKCyKUfIll8y1sSDgzV8=";
  };

  nativeBuildInputs = [
    typescript_5
  ];

  dontNpmPrune = true;
  npmWorkspace = "src/sequentialthinking";
  npmDepsHash = "sha256-psy1XH4DuZu2+tkHpe/bQw3R7uNr8nF5u/AFKoxJeTg=";

  # TODO: revisit this when https://github.com/NixOS/nixpkgs/pull/333759 has landed
  postInstall = ''
    rm -rf $out/lib/node_modules/@modelcontextprotocol/servers/node_modules/@modelcontextprotocol/server-filesystem
    rm -rf $out/lib/node_modules/@modelcontextprotocol/servers/node_modules/@modelcontextprotocol/server-memory
    rm -rf $out/lib/node_modules/@modelcontextprotocol/servers/node_modules/@modelcontextprotocol/server-everything
    rm -rf $out/lib/node_modules/@modelcontextprotocol/servers/node_modules/@modelcontextprotocol/server-sequential-thinking
    rm -rf $out/lib/node_modules/@modelcontextprotocol/servers/node_modules/.bin
  '';

  meta = {
    changelog = "https://github.com/modelcontextprotocol/servers/releases/tag/${finalAttrs.version}";
    description = "MCP server for sequential thinking and problem solving";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mcp-server-sequential-thinking";
    platforms = lib.platforms.all;
  };
})
