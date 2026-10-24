{
  lib,
  buildNpmPackage,
  yq-go,
  typescript_7,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-server-memory";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sg1006mrZiVZTCiBjuYXqurWM5yDPxMKVOyOC+e7C4U=";
  };

  postPatch = ''
        yq -i '.compilerOptions.types = ["node"]' tsconfig.json
    # Remove this since it fails during `npmInstallHook` otherwise
        substituteInPlace src/memory/package.json \
          --replace-fail "prepare" "dont-prepare"
  '';

  nativeBuildInputs = [
    yq-go
    typescript_7
  ];

  npmWorkspace = "src/memory";
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
    description = "MCP server for enabling memory for Claude through a knowledge graph";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mcp-server-memory";
    platforms = lib.platforms.all;
  };
})
