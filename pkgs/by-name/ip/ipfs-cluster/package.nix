{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "1.1.3";

  vendorHash = "sha256-VVejr6B7eDNNQF34PS/PaQ50mBNZgzJS50aNzbLJgCg=";

  src = fetchFromGitHub {
    owner = "ipfs-cluster";
    repo = "ipfs-cluster";
    rev = "v${version}";
    hash = "sha256-C3bBtZsDcYy6I0wmaYIDwhmGJVNcWq+rCdi5WHUzvB8=";
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
