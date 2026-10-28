{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gitMinimal,
}:

buildGoModule (finalAttrs: {
  pname = "snip";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "edouard-claude";
    repo = "snip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-17vAgwuOrDN81+XKa2vn60T9RyZktOoF2xfF/RE+BNw=";
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
