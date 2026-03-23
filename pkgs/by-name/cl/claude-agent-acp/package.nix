{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "claude-agent-acp";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-agent-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6c6bHuso3diW5ZfHiM2xcxGDTNG0LIL0TZd0MFVpW/E=";
  };

  npmDepsHash = "sha256-UtiIcjgNCYMFrRpO5AlUbOyutJ3ipwIbcpMi2BqawEk=";

  meta = {
    description = "ACP-compatible coding agent powered by the Claude Agent SDK";
    homepage = "https://github.com/zed-industries/claude-agent-acp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ storopoli ];
    mainProgram = "claude-agent-acp";
  };
})
