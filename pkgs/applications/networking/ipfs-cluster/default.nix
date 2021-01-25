{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "0.13.1";

  vendorSha256 = "0ls6d5ijl8bbh48w0i30mwd4a4na93iw9xqpbw23lnb8pvskaggh";

  patches = [
      ./test.patch
  ];

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    rev = "v${version}";
    sha256 = "0kmsa7cnk88wrplsjysrpg6n0gd0risnhw0kh33jqx0fcg12b7h8";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://cluster.ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jglukasik ];
  };
}
