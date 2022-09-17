{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "1.0.3";

  vendorSha256 = "sha256-Mafm0gAeTSX+JoaJjSF37LqHYB33GGkYovEtoSKgLy8=";

  src = fetchFromGitHub {
    owner = "ipfs-cluster";
    repo = "ipfs-cluster";
    rev = "v${version}";
    sha256 = "sha256-mRmRIFygC5pkVzdaRXVv0vmYZHssm3dsIl/2A0DQ+ks=";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://ipfscluster.io";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Luflosi jglukasik ];
  };
}
