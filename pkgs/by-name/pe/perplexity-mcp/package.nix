{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "0-unstable-2026-07-30";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "df5e29a5a17c694b5de144c7a3ac56d3377bc079";
    hash = "sha256-U+nrAYQdENZ9Aw6H7/rU0cXXUj0+35Srj8wwgM7AcnE=";
  };

  npmDepsHash = "sha256-GHdBn7PA7+eV3+3sUX18f2dawK79X/o68IqzBv6SB0I=";

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
