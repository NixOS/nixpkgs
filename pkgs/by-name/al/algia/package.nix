{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "algia";
  version = "0.0.87";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "algia";
    tag = "v${version}";
    hash = "sha256-8E48TLxA+kGObE08NJ3oFsLUY+y1LKQ6f8+kw7EhAzY=";
  };

  vendorHash = "sha256-Yt95kSXAIBxHgX+VUefKrumg9thuvh3c+gnSu/2PSQY=";

  meta = {
    description = "CLI application for nostr";
    homepage = "https://github.com/mattn/algia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "algia";
  };
}
