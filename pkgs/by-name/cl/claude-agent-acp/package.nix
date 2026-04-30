{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  claude-code,
}:

buildNpmPackage (finalAttrs: {
  pname = "claude-agent-acp";
  version = "0.31.4";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-agent-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cXTtDekC0+n1NCgTzIyGSqHEgpgdHP6EVI23L4nCbWE=";
  };

  npmDepsHash = "sha256-PmcE99h303iOH5OJ4wCwxgR+0zVJM8O5A3ZyBgPxJeM=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/claude-agent-acp \
      --prefix CLAUDE_CODE_EXECUTABLE ${lib.getExe claude-code}
  '';

  meta = {
    description = "ACP-compatible coding agent powered by the Claude Agent SDK";
    homepage = "https://github.com/zed-industries/claude-agent-acp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      amadejkastelic
      storopoli
    ];
    mainProgram = "claude-agent-acp";
  };
})
