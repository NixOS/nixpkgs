{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-grafana";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mcp-grafana";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e05lKLThUsg9+IWr47GfX0Pf1cjE9tE6Nk6gcsfrSkY=";
  };

  vendorHash = "sha256-V3BA9sOYuiT4BYf/iJ5GSdCGEbPmuDo2fVFfLss2Gko=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/grafana/mcp-grafana/v2.version=${finalAttrs.version}"
  ];

  postInstall = ''
    rm $out/bin/{jsonschema,openapi}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "MCP server for Grafana";
    homepage = "https://github.com/grafana/mcp-grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "mcp-grafana";
  };
})
