{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx }:

buildGoPackage rec {
  name = "ipfs-${version}";
  version = "0.4.13";
  rev = "v${version}";

  goPackagePath = "github.com/ipfs/go-ipfs";

  extraSrcPaths = [
    (fetchgx {
      inherit name src;
      sha256 = "150lhf5999jz0nck5s0fs0fp3pgaj85s7dndh68h9caw1fwpwb4f";
    })
  ];

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "go-ipfs";
    inherit rev;
    sha256 = "103mlsnqfnnqxh4phr192haaiv98d1bwpvca1sqrxz1216r5x0ik";
  };

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = https://ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
