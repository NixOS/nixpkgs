{
  lib,
  fetchFromGitHub,
  buildGoPackage,
  pkg-config,
  libappindicator-gtk3,
}:

buildGoPackage rec {
  pname = "syncthing-tray";
  version = "0.7";

  goPackagePath = "github.com/alex2108/syncthing-tray";

  src = fetchFromGitHub {
    owner = "alex2108";
    repo = "syncthing-tray";
    rev = "v${version}";
    sha256 = "0869kinnsfzb8ydd0sv9fgqsi1sy5rhqg4whfdnrv82xjc71xyw3";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libappindicator-gtk3 ];

  meta = with lib; {
    description = "Simple application tray for syncthing";
    homepage = "https://github.com/alex2108/syncthing-tray";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
    mainProgram = "syncthing-tray";
  };
}
