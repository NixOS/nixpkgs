{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "algia";
  version = "0.0.74";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "algia";
    rev = "v${version}";
    hash = "sha256-t6XDw40FTa7QkZmOkgAufWV1aFjQrLWmycp+zcVYQWs=";
  };

  vendorHash = "sha256-fko9WC/Rh5fmoypqBuFKiuIuIJYMbKV+1uQKf5tFil0=";

  meta = {
    description = "CLI application for nostr";
    homepage = "https://github.com/mattn/algia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "algia";
  };
}
