{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-grafana";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mcp-grafana";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0JwhO/CUewthPk5eAKOvQeweJFQ1A3zHIz8Wv8F/7vw=";
  };

  vendorHash = "sha256-szMCIObafZ0HpNuDbFTz5VhLk2DBx3vEm/UdLJU77v8=";

  subPackages = [ "cmd/mcp-grafana" ];

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/grafana/mcp-grafana/v2.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MCP server for Grafana";
    homepage = "https://github.com/grafana/mcp-grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "mcp-grafana";
  };
})
