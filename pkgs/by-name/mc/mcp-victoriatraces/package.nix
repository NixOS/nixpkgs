{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-victoriatraces";
  version = "1.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "mcp-victoriatraces";
    tag = "v${finalAttrs.version}";
    hash = "sha256-As1ERHKytCmFRqg3ndcSQFBFg0MBs6M5zyaGUmIntuU=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/mcp-victoriatraces/..." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MCP server for VictoriaTraces";
    homepage = "https://github.com/VictoriaMetrics/mcp-victoriatraces";
    changelog = "https://github.com/VictoriaMetrics/mcp-victoriatraces/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers._1sixth ];
    mainProgram = "mcp-victoriatraces";
  };
})
