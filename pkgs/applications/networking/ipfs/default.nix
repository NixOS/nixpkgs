{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx }:

buildGoPackage rec {
  name = "ipfs-${version}";
  version = "0.4.5-pre";
  rev = "c99a82d4b53347b32b8d1b0a0df0250e36a13c8d";

  goPackagePath = "github.com/ipfs/go-ipfs";

  extraSrcPaths = [
    (fetchgx {
      inherit name src;
      sha256 = "1lq80digf2r91k9fgipd8kfvw7q8gb3khv7xwhskxfgbzc3mcz06";
    })
  ];

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "go-ipfs";
    inherit rev;
    sha256 = "0pq7f7id4sivmfgpgak3fnvjkl4db931v3yk0b50kl0kd3rz35pl";
  };

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = https://ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
