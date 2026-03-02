{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "0-unstable-2026-01-28";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "3f15235fb04698bff33bff673d4725842371cc1d";
    hash = "sha256-cv8d5/wH71Nd8/WmcPYqgipX8ZMSWzpoLqOdt97OGfM=";
  };

  npmDepsHash = "sha256-654nkK7IQauZImUzeTf328sDDneUkkTSuzlbOmXZXDM=";

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
