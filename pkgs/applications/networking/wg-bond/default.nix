{ lib, rustPlatform, fetchFromGitLab, wireguard-tools, makeWrapper }:
rustPlatform.buildRustPackage rec {
  pname = "wg-bond";
  version = "0.2.1";

  src = fetchFromGitLab {
    owner = "cab404";
    repo = "wg-bond";
    rev = "v${version}";
    hash = "sha256-6/3qtnvJ0iZ+aAvhPkDh/bSV7aNgdoTtFrA8SjGHEho=";
  };

  cargoHash = "sha256-HNiIOlGGhd/FDzUwOD+OEvdYwNXZwCaAfErkwtilL/Q=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/wg-bond --set PATH ${
      lib.makeBinPath [ wireguard-tools ]
    }
  '';

  meta = with lib; {
    description = "Wireguard configuration manager";
    homepage = "https://gitlab.com/cab404/wg-bond";
    changelog = "https://gitlab.com/cab404/wg-bond/-/releases#v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ cab404 ];
    mainProgram = "wg-bond";
  };
}
