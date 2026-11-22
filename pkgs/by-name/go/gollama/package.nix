{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gollama";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "sammcj";
    repo = "gollama";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NoMWyIS4GMbphF5Pi508B/zOF2gkT/pskAXahZsDwc4=";
  };

  vendorHash = "sha256-3mrbjz03+1mW44BrER4oBxYJPC50VMuOspR/7jOtI1g=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go manage your Ollama models";
    homepage = "https://github.com/sammcj/gollama";
    changelog = "https://github.com/sammcj/gollama/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "gollama";
  };
})
