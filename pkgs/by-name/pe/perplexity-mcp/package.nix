{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "0-unstable-2026-07-27";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "9f7dd0b1951c7421f930d1af8ff10e92473de0f9";
    hash = "sha256-B3cv427UwR8il/604tW8tnzQ35V1sHF3h/Cn6cWjJY0=";
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
