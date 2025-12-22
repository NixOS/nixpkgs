{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "0-unstable-2025-12-19";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "29dddc491b5853d8be66aac9e0ffdce105aa7f07";
    hash = "sha256-GBA4NPGf6fbj8DJ6Cke4DD03jMe3Ts6uGu2PoLhOaUg=";
  };

  npmDepsHash = "sha256-aAIH/z/5BSbLYmAc7ZyPEIoblLdHlncp8uFGFDebots=";

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
