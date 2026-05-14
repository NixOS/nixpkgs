{
  lib,
  buildNpmPackage,
  typescript,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-server-sequential-thinking";
  version = "2026.1.26";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = finalAttrs.version;
    hash = "sha256-uULXUEHFZpYm/fmF6PkOFCxS+B+0q3dMveLG+3JHrhk=";
  };

  nativeBuildInputs = [
    typescript
  ];

  dontNpmPrune = true;
  npmWorkspace = "src/sequentialthinking";
  npmDepsHash = "sha256-jmz4JdpeHH07vJQFntBwrENbJaIcOuZMb7+qf497VOE=";

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
    mainProgram = "mcp-server-memory";
    platforms = lib.platforms.all;
  };
})
