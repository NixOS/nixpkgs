{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "azure-devops-mcp";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "azure-devops-mcp";
    tag = "v${version}";
    hash = "sha256-tIIPKjxAp5+rnl+WCfGaSlMt71A+v2Saq/E+pinBJqU=";
  };

  npmDepsHash = "sha256-I8eCzTXjOw+91aOTcO5L5Ha4s59E2oJ69jpl+8aZij8=";

  npmBuildScript = "build";

  meta = {
    description = "MCP server for Azure DevOps";
    homepage = "https://github.com/microsoft/azure-devops-mcp";
    license = lib.licenses.mit;
    mainProgram = "mcp-server-azuredevops";
    maintainers = with lib.maintainers; [ Jozef833 ];
  };
}
