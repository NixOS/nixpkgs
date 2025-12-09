{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "algia";
  version = "0.0.93";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "algia";
    tag = "v${version}";
    hash = "sha256-B1win7mTU1vrdhhm8jtbemVYwUWYlEpoLN4d4FI65Is=";
  };

  vendorHash = "sha256-JTTWVs0KwceiLy6tpyd48zORiXLc18zwgG1c+ceivKU=";

  meta = {
    description = "CLI application for nostr";
    homepage = "https://github.com/mattn/algia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "algia";
  };
}
