{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gitMinimal,
}:

buildGoModule (finalAttrs: {
  pname = "snip";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "edouard-claude";
    repo = "snip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y88ZHg29Z/QBZk8YWXp287Rel7DpPESYAlbqt5hj1nc=";
  };

  vendorHash = "sha256-2MxFZqjNuLzcuu+bsLyOyHIakCxh7j0FUx8LsjZRhrY=";

  nativeCheckInputs = [ gitMinimal ];

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
