{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "0-unstable-2026-09-25";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "c58e4ad254608952606f09a40934ab6cca65bfad";
    hash = "sha256-j0DiITMVEw7e6Cw42kW5iPwIdRt//X2a3Dm2S3IXsbU=";
  };

  npmDepsHash = "sha256-wKw19ha7hQrBTM0caEBZazV6qC+VXihV6i0nf8H/u+Q=";

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
