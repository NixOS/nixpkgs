{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "0-unstable-2026-06-17";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "7c8993499c808e5b3c11b8c16736687ecef0f457";
    hash = "sha256-6uGJJ+xEVoUZYSPTMr4DSh6j4bq8nYSsUG5XDC9WKag=";
  };

  npmDepsHash = "sha256-UWxUjneYQeM9GlbIr/zW2TrZuPJ2QOTKwbXKNuVazFg=";

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
