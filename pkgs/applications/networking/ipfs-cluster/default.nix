{ stdenv, buildGoModule, fetchFromGitHub, fetchgx, gx-go }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "0.12.1";
  rev = "v${version}";

  vendorSha256 = "1n0zb3v83wsy8y3k7xbpjc2ykh1b2n6p10d5wkflhga49q7rf64h";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    inherit rev;
    sha256 = "1jh6ynj50jd4w79widaqrgm3h3yz5h03vq0lbsx717a8d9073blh";
  };

  meta = with stdenv.lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://cluster.ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jglukasik ];
  };
}