{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "snip";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "edouard-claude";
    repo = "snip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-af27LOFlUxMrLFjubeTTcdGYZtU86MJlVpoDgJnjTtg=";
  };

  vendorHash = "sha256-2MxFZqjNuLzcuu+bsLyOyHIakCxh7j0FUx8LsjZRhrY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI proxy that reduces LLM token consumption by filtering verbose shell output";
    homepage = "https://github.com/edouard-claude/snip";
    changelog = "https://github.com/edouard-claude/snip/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gdifolco ];
    mainProgram = "snip";
  };
})
