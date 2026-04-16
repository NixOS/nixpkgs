{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-grafana";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mcp-grafana";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cJjapd2phI4NgMAPzsKrs74+sEK7ykfKHQx24FVpHoQ=";
  };

  vendorHash = "sha256-a9VgfzJmbTudYSLqhBBnkpq37xghtxWTzpcd7rMlZmA=";

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
