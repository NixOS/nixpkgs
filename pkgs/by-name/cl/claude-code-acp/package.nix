{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "claude-code-acp";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-code-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sq4m4w8ZmgU7Quel5gUwmvq0rumo+G1SkCt7fQsg+8M=";
  };

  npmDepsHash = "sha256-ElxSaU74txRC/eH7S+Uv33Ji7y2HE6rZU2DmEPICTko=";

  meta = {
    description = "ACP-compatible coding agent powered by the Claude Code SDK";
    homepage = "https://github.com/zed-industries/claude-code-acp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ storopoli ];
    mainProgram = "claude-code-acp";
  };
})
