{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "base16-universal-manager";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "pinpox";
    repo = "base16-universal-manager";
    rev = "v${version}";
    hash = "sha256-9KflJ863j0VeOyu6j6O28VafetRrM8FW818qCvqhaoY=";
  };

  vendorHash = "sha256-U28OJ5heeiaj3aGAhR6eAXzfvFMehAUcHzyFkZBRK6c=";

  meta = with lib; {
    description = "Universal manager to set base16 themes for any supported application";
    homepage = "https://github.com/pinpox/base16-universal-manager";
    license = licenses.mit;
    maintainers = with maintainers; [ jo1gi ];
    mainProgram = "base16-universal-manager";
  };
}
