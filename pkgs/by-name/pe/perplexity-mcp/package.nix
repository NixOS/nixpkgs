{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "0-unstable-2026-02-26";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "95c7a8e9307bc067cbbcf8cbc4290e3ca670eea4";
    hash = "sha256-J9ZM7GaaK4JZYlYHDxBUHhPOUPW61Ppdj3CHJjAd8rM=";
  };

  npmDepsHash = "sha256-/AtK/jCYB1Wd3DO49loNrmWlnk80OoTxdsFRp5/OW7A=";

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
