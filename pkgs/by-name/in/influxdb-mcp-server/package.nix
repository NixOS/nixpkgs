{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "influxdb-mcp-server";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "idoru";
    repo = "influxdb-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iAMTphvC/lLhOWC6j3WhMaxZL9x5RgsLBGNJ3RvD/2c=";
  };

  npmDepsHash = "sha256-CLFDfljtmL0dNI/qOzZiooFlr5fF+lHaCy/i+OTjgN8=";

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
