{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "algia";
  version = "0.0.84";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "algia";
    rev = "v${version}";
    hash = "sha256-i7rSmLFtUFSA1pW5IShYnTxjtwZ5z31OP4kVcMQgMxA=";
  };

  vendorHash = "sha256-8zAGkz17U7j0WWh8ayLowVhNZQvbIlA2YgXMgVIHuFg=";

  meta = with lib; {
    description = "CLI application for nostr";
    homepage = "https://github.com/mattn/algia";
    license = licenses.mit;
    maintainers = with maintainers; [ haruki7049 ];
    mainProgram = "algia";
  };
}
