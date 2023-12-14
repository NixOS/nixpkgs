{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "quorum";
  version = "23.4.0";

  src = fetchFromGitHub {
    owner = "Consensys";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-N8MlDHo6LQ/m9xFUeOCm6bqDtjnCc86i/s4ebFLjUT0=";
  };

  vendorHash = "sha256-dTYKGFqVaAnspvKhfBU10bpSzhtQHGTm6KxnNKUVAIg=";

  patches = [
    # Add missing requirements
    ./go.mod.patch
  ];

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
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
