{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "claude-code-acp";
  version = "0.10.8";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-code-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eQhUXdYynBCv/6P60JRo43MDpWEPdIdEEQnFeY9AnhA=";
  };

  npmDepsHash = "sha256-dzgqmJPU3hIcQag+PnS1n8U05Mx+WN27d1Hwyy7CdZo=";

  meta = {
    description = "ACP-compatible coding agent powered by the Claude Code SDK";
    homepage = "https://github.com/zed-industries/claude-code-acp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ storopoli ];
    mainProgram = "claude-code-acp";
  };
})
