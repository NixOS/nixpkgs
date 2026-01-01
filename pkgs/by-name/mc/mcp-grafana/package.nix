{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-grafana";
<<<<<<< HEAD
  version = "0.7.10";
=======
  version = "0.7.9";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mcp-grafana";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-DDkIWCJneL7l59CThzPkHzcB/lcUZrcVDZO/nWsZ2ss=";
  };

  vendorHash = "sha256-4dOsXrwUk+muYLIec9hBdMl/W3lk/pMvliEWeYrU5zQ=";
=======
    hash = "sha256-oXF1TvapQUYvU3LS/cnjcoHMuELw5X/OkuSSyuS1ClY=";
  };

  vendorHash = "sha256-vy+Ku4UISkFSoRUpgY6dNvaXKpCRRfGl8BNknk6DCXs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
