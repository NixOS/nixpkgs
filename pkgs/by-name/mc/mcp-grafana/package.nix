{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-grafana";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mcp-grafana";
    tag = "v${finalAttrs.version}";
    hash = "sha256-32xQaQgDF2uTrqoITj44wMv3mZA/NOXKU4ssU2Uip80=";
  };

  vendorHash = "sha256-SovR9UxTqN397oczKgJqlJ9iOFnCrZGqPWhhfcjSNPg=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    rm $out/bin/jsonschema
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "MCP server for Grafana";
    homepage = "https://github.com/grafana/mcp-grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "mcp-grafana";
  };
})
