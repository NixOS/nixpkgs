{ stdenv, buildGoModule, fetchFromGitHub, fetchgx, gx-go }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "0.11.0";
  rev = "v${version}";

  modSha256 = "03bqwg9nqh7w6j887gzxr2mcn14jc8f07z896b3swg5wzaz1i6hs";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    inherit rev;
    sha256 = "0q5lanm2zdwwhdwv05fssb34y4y4dha3dq7x1iaabbf70lpqv6yx";
  };

  meta = with stdenv.lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = https://cluster.ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jglukasik ];
  };
}

