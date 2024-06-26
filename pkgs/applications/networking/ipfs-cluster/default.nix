{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "1.1.1";

  vendorHash = "sha256-pCp2ox08wWUdAnqBqoiMLy/qBQg1PsNnMl8nLCNifC8=";

  src = fetchFromGitHub {
    owner = "ipfs-cluster";
    repo = "ipfs-cluster";
    rev = "v${version}";
    hash = "sha256-FnofI7IpG0hA9/60cILbQ7xnGKJ2zdYk/pRZPTyOmzA=";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://ipfscluster.io";
    license = licenses.mit;
    maintainers = with maintainers; [
      Luflosi
      jglukasik
    ];
  };
}
