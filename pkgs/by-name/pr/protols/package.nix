{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    rev = "refs/tags/${version}";
    hash = "sha256-Y2gmOlQO6yP/sP2z4NJGbJimlSC5Q7B9Lw8BinzOwHA=";
  };

  cargoHash = "sha256-xi1nJ0/rIDYUGJkxtjAysR77+FtmpD97OuuFX0oLuc0=";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
