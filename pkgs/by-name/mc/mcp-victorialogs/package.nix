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
  pname = "mcp-victorialogs";
  version = "1.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "mcp-victorialogs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-esfd6Eg1j2BCgee1T5tiIdSPWVEBqhI4UGDKRFYyn3s=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/mcp-victorialogs/..." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  npmDeps = fetchNpmDeps {
    name = "mcp-victorialogs-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/web";
    hash = "sha256-B8kEHH7vv1Mp1gLwsFLaFkUyNZsq2ZZHH9U6+a7JlOA=";
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
    description = "MCP server for VictoriaLogs";
    homepage = "https://github.com/VictoriaMetrics/mcp-victorialogs";
    changelog = "https://github.com/VictoriaMetrics/mcp-victorialogs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers._1sixth ];
    mainProgram = "mcp-victorialogs";
  };
})
