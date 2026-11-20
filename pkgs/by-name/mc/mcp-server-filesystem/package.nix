{
  lib,
  buildNpmPackage,
  yq-go,
  typescript_7,
  fetchFromGitHub,
  fetchNpmDeps,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-server-filesystem";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yYfNwuNwzgguvErZRzc+M7cDt/05pU7iZuiF1L3c4hE=";
  };

  postPatch = ''
    yq -i '.compilerOptions.types = ["node"]' tsconfig.json
    # Remove this since it fails during `npmInstallHook` otherwise
    substituteInPlace src/filesystem/package.json \
      --replace-fail "prepare" "dont-prepare"
  '';

  nativeBuildInputs = [
    yq-go
    typescript_7
  ];

  npmWorkspace = "src/filesystem";
  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-zq32JpOkYfNvPr6Vcej/zi1+r4c1P/tnb+zpr72zdBs=";
  };

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
    description = "MCP server for filesystem access";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mcp-server-filesystem";
    platforms = lib.platforms.all;
  };
})
