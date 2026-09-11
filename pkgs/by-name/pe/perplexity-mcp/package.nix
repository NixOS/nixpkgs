{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "0-unstable-2026-10-21";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "cd1d27cffe56739819abb3e56a18e26dbd88c487";
    hash = "sha256-yJyFuJFP4JXwyAPcDDS7XGc+3I6h6a4uotKsWVUmasY=";
  };

  npmDepsHash = "sha256-XHV+F/rQ4fkygfXmRQWPNU6jQ7EFA2lkETMU6GGxujs=";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
      ];
    };
  };

  meta = {
    description = "The official MCP server implementation for the Perplexity API Platform";
    homepage = "https://github.com/perplexityai/modelcontextprotocol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "perplexity-mcp";
    platforms = lib.platforms.all;
  };
})
