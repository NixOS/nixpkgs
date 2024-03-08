{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "1.0.8";

  vendorHash = "sha256-uwDXUy9mh/DvLuwj8Htm55wla5/JjvZH5ztJbqnox+U=";

  src = fetchFromGitHub {
    owner = "ipfs-cluster";
    repo = "ipfs-cluster";
    rev = "v${version}";
    hash = "sha256-qZUoYJjw3Qac7Kmg5PfNWTDM8Ra3rqrbjScLbK6FRx4=";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://ipfscluster.io";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi jglukasik ];
  };
}
