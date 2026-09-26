{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "0-unstable-2026-08-27";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "c73c8561bbc2d9eb666334a53c311b50f4f4cf76";
    hash = "sha256-zOYRSTK5N79l3jAEnPMuBrYDMyD5zm0QKEopqwlV7/E=";
  };

  npmDepsHash = "sha256-eKLKHkoXcmk1OdPkgIQjPKBFXEwnV7nKeE98weE25+0=";

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
