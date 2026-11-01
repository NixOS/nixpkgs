{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "influxdb-mcp-server";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "idoru";
    repo = "influxdb-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NhriEWGByyaePcxeRE0+dPxpgYSfRj2Z5FodC956y+E=";
  };

  npmDepsHash = "sha256-tdHNWu7zCN28OKnCBbnfe/Bb2btFdXYtplAllA6ZpGo=";

  dontNpmBuild = true;

  meta = {
    description = "An MCP Server for querying InfluxDB";
    homepage = "https://github.com/idoru/influxdb-mcp-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "influxdb-mcp-server";
    platforms = lib.platforms.all;
  };
})
