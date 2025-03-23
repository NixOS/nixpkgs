{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "1.1.2";

  vendorHash = "sha256-y8eE1GYFiHbLY5zeSSQO86I4buZZJROGp7KzXbKjMqI=";

  src = fetchFromGitHub {
    owner = "ipfs-cluster";
    repo = "ipfs-cluster";
    rev = "v${version}";
    hash = "sha256-CpMnhqRlikKdPT3/tsLpKdKm6icePDsmqEnUEBwvCT0=";
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
