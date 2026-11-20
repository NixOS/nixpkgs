{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "algia";
  version = "0.0.139";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "algia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9cW8OEU2GI3g2XrCTo/cKzqq/BubAr67TjEWE9cx1a4=";
  };

  vendorHash = "sha256-mim8EImPFHF2vf1vCi9jgECbVAOB32oXxsPMgUwYDBA=";

  meta = {
    description = "CLI application for nostr";
    homepage = "https://github.com/mattn/algia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "algia";
  };
})
