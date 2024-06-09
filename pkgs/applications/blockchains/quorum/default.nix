{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "quorum";
  version = "24.4.0";

  src = fetchFromGitHub {
    owner = "Consensys";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vQyKguoSUU6Drkg8XqWtK8Ow/B9dqDKkKq6yeDQk1c0=";
  };

  vendorHash = "sha256-YK2zpQz4pAFyA+aHOn6Nx0htl5SJ2HNC+TDV1RdLQJk=";

  subPackages = [
    "cmd/geth"
    "cmd/bootnode"
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A permissioned implementation of Ethereum supporting data privacy";
    homepage = "https://consensys.net/quorum/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ mmahut ];
    platforms = platforms.linux;
  };
}
