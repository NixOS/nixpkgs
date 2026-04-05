{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "0-unstable-2026-03-23";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "79ce21c5798f6993af7cac81da8067a6dc81e20d";
    hash = "sha256-URatUVDEOmcwkIsSZ+DepeBuKS2HDu8V5niYxwtUBLE=";
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
