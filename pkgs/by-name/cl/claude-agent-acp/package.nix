{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  claude-code,
}:

buildNpmPackage (finalAttrs: {
  pname = "claude-agent-acp";
  version = "0.103.0";

  src = fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i1t/v2fcg+Xy383A4qzKrOHX7ZqHQUeFZ72taCFtdp0=";
  };

  npmDepsHash = "sha256-AiGY73qZIjSot8tRekqZ9PrRVZBnvJWhVdtMup+QuLM=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/claude-agent-acp \
      --set-default CLAUDE_CODE_EXECUTABLE ${lib.getExe claude-code}
  '';

  meta = {
    description = "ACP-compatible coding agent powered by the Claude Agent SDK";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    changelog = "https://github.com/agentclientprotocol/claude-agent-acp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      amadejkastelic
      storopoli
    ];
    mainProgram = "claude-agent-acp";
  };
})
