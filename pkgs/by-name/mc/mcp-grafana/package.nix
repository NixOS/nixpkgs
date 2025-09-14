{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-grafana";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mcp-grafana";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bku8vbNjIggaVzhTXZYBgT7TcI9tAUUUrCjl+cSN9OU=";
  };

  vendorHash = "sha256-42UHI5Z5bgnW40DsRPzoKQdZQ+k785K60gWMp5ehLfU=";

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
