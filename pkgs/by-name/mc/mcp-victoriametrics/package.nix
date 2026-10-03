{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  nix-update-script,
  nodejs,
  npmHooks,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-victoriametrics";
  version = "1.20.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "mcp-victoriametrics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7kN7qwsvTL0scfBxMO/nrvikiysUxPY8nSFkhJsgGDM=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/mcp-victoriametrics/..." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  npmDeps = fetchNpmDeps {
    name = "mcp-victoriametrics-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/web";
    hash = "sha256-Q6Ljqtbwz0pEvUcz8keps8Nr8xzOUusW0zBZq1mkz/Q=";
  };

  npmRoot = "web";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  preBuild = ''
    npm --prefix web run build
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MCP server for VictoriaMetrics";
    homepage = "https://github.com/VictoriaMetrics/mcp-victoriametrics";
    changelog = "https://github.com/VictoriaMetrics/mcp-victoriametrics/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers._1sixth ];
    mainProgram = "mcp-victoriametrics";
  };
})
