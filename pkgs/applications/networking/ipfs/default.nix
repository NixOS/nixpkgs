{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx }:

buildGoPackage rec {
  name = "ipfs-${version}";
  version = "0.4.10";
  rev = "4679f806bd00c0a5299c22c82d1fbfdbad928e6d";

  goPackagePath = "github.com/ipfs/go-ipfs";

  extraSrcPaths = [
    (fetchgx {
      inherit name src;
      sha256 = "1khlsahv9vqx3h2smif5wdyb56jrza415hqid7883pqimfi66g3x";
    })
  ];

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "go-ipfs";
    inherit rev;
    sha256 = "1j3az0nhjisb5dxp1a4g8w17y17xjikvcsy4qrg0fm43ybpkhhvw";
  };

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = https://ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
