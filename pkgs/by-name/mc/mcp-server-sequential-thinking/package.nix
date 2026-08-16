{
  lib,
  buildNpmPackage,
  typescript,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-server-sequential-thinking";
  version = "2026.7.4";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = finalAttrs.version;
    hash = "sha256-rBdJoTC1wOEMbAAeSccFqaHL7lacf2SFfxZ/pp2Lx90=";
  };

  nativeBuildInputs = [
    typescript
  ];

  dontNpmPrune = true;
  npmWorkspace = "src/sequentialthinking";
  npmDepsHash = "sha256-KhlTXcS+VDSPGnEus9fA0xhIxfTGwX1Cr5hbxFvdc2k=";

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
