{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "algia";
  version = "0.0.91";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "algia";
    tag = "v${version}";
    hash = "sha256-VsQBiD8OE2NHwMlYrCG43ukuBHE0bkKFt4BxsNUvLAo=";
  };

  vendorHash = "sha256-kp52vbvE6QY0SEY/2D1f1EbDzqweQkNOepN0We4I9ko=";

  meta = {
    description = "CLI application for nostr";
    homepage = "https://github.com/mattn/algia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "algia";
  };
}
