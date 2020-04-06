{ stdenv, buildGoModule, fetchFromGitHub, fetchgx, gx-go }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "0.12.1";
  rev = "v${version}";

  modSha256 = "0bn47lcb9plzvl2vqqj7p33ishz6bbqpsgf2i6p34g13bwwpq647";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    inherit rev;
    sha256 = "1jh6ynj50jd4w79widaqrgm3h3yz5h03vq0lbsx717a8d9073blh";
  };

  meta = with stdenv.lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = https://cluster.ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jglukasik ];
  };
}

