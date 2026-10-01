{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sessiongrep";
  version = "0-unstable-2026-06-03";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "braincompany";
    repo = "sessiongrep";
    rev = "76e08a0a338a0e7b6f666c171d15bf275c9916cb";
    hash = "sha256-hNMvHD7bgWII30+ySHzTGRzAb/InFBtkjiqNukEh61U=";
  };

  cargoHash = "sha256-Xvhux42slDfXN1h+JkJj+0tKYoLMNUD/TaMJm5r0d3k=";

  meta = {
    description = "Local-first search, inspection, export, and resume for Claude Code, Codex CLI, and Cursor sessions, with an MCP server for agent-driven recall";
    homepage = "https://github.com/braincompany/sessiongrep";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guilhermeprokisch ];
    mainProgram = "sessiongrep";
  };
})
