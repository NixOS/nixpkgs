{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "1.1.0";

  vendorHash = "sha256-U7zh0MmuDmKQWa4uyoFDctPUfq+52Im6t2TFyWIGXAs=";

  src = fetchFromGitHub {
    owner = "ipfs-cluster";
    repo = "ipfs-cluster";
    rev = "v${version}";
    hash = "sha256-z08LLJ/SI833wMpZJ25WDrc66Y4R5i2uGlE7Nc30Kk0=";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://ipfscluster.io";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi jglukasik ];
  };
}
