{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-hub";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "ravitemer";
    repo = "mcp-hub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KakvXZf0vjdqzyT+LsAKHEr4GLICGXPmxl1hZ3tI7Yg=";
  };

  npmDepsHash = "sha256-nyenuxsKRAL0PU/UPSJsz8ftHIF+LBTGdygTqxti38g=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Centralized manager for Model Context Protocol (MCP) servers";
    homepage = "https://github.com/ravitemer/mcp-hub";
    changelog = "https://github.com/ravitemer/mcp-hub/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.neovim ];
    mainProgram = "mcp-hub";
  };
})
