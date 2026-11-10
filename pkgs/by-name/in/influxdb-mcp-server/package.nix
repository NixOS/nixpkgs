{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "influxdb-mcp-server";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "idoru";
    repo = "influxdb-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D3+977YxOinwzTi1x80y0Iz6BpaLnwIMqr20fGTcqQs=";
  };

  npmDepsHash = "sha256-drlBbBSwsm3z8/F838Q2mNiEH6KAK9U/hGaMkOu8yAI=";

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
