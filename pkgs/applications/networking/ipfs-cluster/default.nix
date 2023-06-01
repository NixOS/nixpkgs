{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "1.0.6";

  vendorHash = "sha256-IRR10wC05dv4d170Iweuxdy/JEnYjvdW0h5nS1ht9cg=";

  src = fetchFromGitHub {
    owner = "ipfs-cluster";
    repo = "ipfs-cluster";
    rev = "v${version}";
    hash = "sha256-2En7morOodWvtNZGAZhl1EZJCCHdrYSUA1WBYGkjnYI=";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://ipfscluster.io";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Luflosi jglukasik ];
  };
}
