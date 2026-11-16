{
  lib,
  buildNpmPackage,
  yq-go,
  typescript_7,
  fetchFromGitHub,
  fetchNpmDeps,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-server-sequential-thinking";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-edwibnJdNuOAF31FbZQ/CVDxM5WyIxl0ycmebTkWroE=";
  };

  postPatch = ''
    yq -i '.compilerOptions.types = ["node"]' tsconfig.json
    # Remove this since it fails during `npmInstallHook` otherwise
    substituteInPlace src/sequentialthinking/package.json \
      --replace-fail "prepare" "dont-prepare"
  '';

  nativeBuildInputs = [
    yq-go
    typescript_7
  ];

  npmWorkspace = "src/sequentialthinking";
  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-t/Ugjb1nySxNNKcw9IGFAvuUwTBebmWPr1EgANY/DOk=";
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
    description = "MCP server for sequential thinking and problem solving";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mcp-server-sequential-thinking";
    platforms = lib.platforms.all;
  };
})
