{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "0-unstable-2026-10-17";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "6ba09f856ab8da91c171e5d60f0db9803c1753f5";
    hash = "sha256-eb74r282SXlCOQCwF0N2dLaBBrNUaAfYOFH4jKWeL0g=";
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
