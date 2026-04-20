{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "0-unstable-2026-04-14";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "dd5e0785520833ebc95d5e97c8fa68971dcae07b";
    hash = "sha256-hMIPsUsI1e8bOdPQ9t6m4/vGv07NCuC8wnYLUKolNOo=";
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
