{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "influxdb-mcp-server";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "idoru";
    repo = "influxdb-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9JDEAKCgEyhnWxYLomnYU/mazBnDsbb2va9x+cIsgOQ=";
  };

  npmDepsHash = "sha256-83jchkTARy4DxuQmBd5VorWrrQrQccq9lIggAQSk2yE=";

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
