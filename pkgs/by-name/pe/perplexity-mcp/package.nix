{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "0-unstable-2026-03-20";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "8c31448682df546ab39fd7bfee98330eb31e8ff5";
    hash = "sha256-mW/CxYSPoYdFt5rX3DVnLGFNkl5UOaawFfjx/msAkIk=";
  };

  npmDepsHash = "sha256-cyNhqmXowasXt1pObxup/WoHXp2Is+wsHvY59qGn9og=";

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
