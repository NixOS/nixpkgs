{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: rec {
  pname = "mcp-hub";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "ravitemer";
    repo = "mcp-hub";
    rev = "v${version}";
    hash = "sha256-KakvXZf0vjdqzyT+LsAKHEr4GLICGXPmxl1hZ3tI7Yg=";
  };

  npmDepsHash = "sha256-nyenuxsKRAL0PU/UPSJsz8ftHIF+LBTGdygTqxti38g=";

  meta = {
    description = "A centralized manager for Model Context Protocol (MCP) servers with dynamic server management and monitoring";
    homepage = "https://github.com/ravitemer/mcp-hub";
    changelog = "https://github.com/ravitemer/mcp-hub/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lampros ];
    mainProgram = "mcp-hub";
    platforms = lib.platforms.all;
  };
})
