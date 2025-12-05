{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "claude-code-acp";
  version = "0.10.9";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-code-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cSgKMeOW2oYy26HRo5qzoPHuoidqZ3TiLfgQAVbUIXA=";
  };

  npmDepsHash = "sha256-IOTcAylJuDorC6qPiQ2gJFeQu0dR+EAAKcyPsPdR0d0=";

  meta = {
    description = "ACP-compatible coding agent powered by the Claude Code SDK";
    homepage = "https://github.com/zed-industries/claude-code-acp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ storopoli ];
    mainProgram = "claude-code-acp";
  };
})
