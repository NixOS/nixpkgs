{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-grafana";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mcp-grafana";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tONckClFMZxq84h+brFiznN3V3yf4EJW7ry4XZxJSqI=";
  };

  vendorHash = "sha256-vmXj/ocSBi3BzCvYt1hjMAnObZtDPkkiKZ6LW0MqDfI=";

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
