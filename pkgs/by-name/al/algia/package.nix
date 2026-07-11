{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "algia";
  version = "0.0.130";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "algia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QuusIoZfNhETaVJJ8sUy3Zo3VnRUp7cfudDP562ZNLU=";
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
