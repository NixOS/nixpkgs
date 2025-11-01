{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "claude-code-acp";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-code-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kkAQuYP2S5EwIGJV8TLrlYzHOC54vmxEHwwuZD5P1hI=";
  };

  npmDepsHash = "sha256-IR88NP1AiR6t/MLDdaZY1Np0AE7wfqEUfmnohaf0ymc=";

  meta = {
    description = "ACP-compatible coding agent powered by the Claude Code SDK";
    homepage = "https://github.com/zed-industries/claude-code-acp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ storopoli ];
    mainProgram = "claude-code-acp";
  };
})
