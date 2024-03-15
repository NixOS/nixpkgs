{ lib, fetchFromGitHub, buildGoModule, pkg-config, libappindicator-gtk3 }:

buildGoModule rec {
  pname = "syncthing-tray";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "alex2108";
    repo = "syncthing-tray";
    rev = "v${version}";
    hash = "sha256-g/seDpNdoJ1tc5CTh2EuXoeo8XNpa9CaR+s7bW2cySA=";
  };

  vendorHash = "sha256-hGV5bivDUFEbOwU9sU+Eu5Wzz/aZtj6NUkpzHlmZTtw=";

  preBuild = ''
    cp ${./go.mod} go.mod
    cp ${./go.sum} go.sum
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libappindicator-gtk3 ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Simple application tray for syncthing";
    homepage = "https://github.com/alex2108/syncthing-tray";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
    mainProgram = "syncthing-tray";
  };
}
