{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx }:

buildGoPackage rec {
  name = "ipfs-${version}";
  version = "0.4.14";
  rev = "v${version}";

  goPackagePath = "github.com/ipfs/go-ipfs";

  extraSrcPaths = [
    (fetchgx {
      inherit name src;
      sha256 = "0gad5y5clkrk5jsjj9gmrlnx8kbn2vg50vka1b8jg7b55hdvvlcg";
    })
  ];

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "go-ipfs";
    inherit rev;
    sha256 = "0wvjw8jziwhvfwhksg26qlj2irznl5bs2yll9jkv335pnwb5qi3v";
  };

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = https://ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
