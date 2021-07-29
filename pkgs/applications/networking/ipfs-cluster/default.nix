{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "0.14.0";

  vendorSha256 = "sha256-I8UJxqzbcOE6pHsKkktrEXVHurxwe0D20GZZmASdWH4=";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    rev = "v${version}";
    sha256 = "sha256-lB0sYsbZfUJgQVNEFLoXNFszWYxlXNEQbRQWA7fRT2A=";
  };

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://cluster.ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Luflosi jglukasik ];
  };
}
