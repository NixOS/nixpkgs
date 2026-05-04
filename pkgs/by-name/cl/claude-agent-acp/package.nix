{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "claude-agent-acp";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-agent-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-egYGwkN8iexw42EIhUgKb+QuAKfH4lKts0lftzfHAiY=";
  };

  npmDepsHash = "sha256-sUB/S3EycM3FGibAaZMA1T7tCyDu2XfkSg86qcABmYk=";

  meta = {
    description = "ACP-compatible coding agent powered by the Claude Agent SDK";
    homepage = "https://github.com/zed-industries/claude-agent-acp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ storopoli ];
    mainProgram = "claude-agent-acp";
  };
})
