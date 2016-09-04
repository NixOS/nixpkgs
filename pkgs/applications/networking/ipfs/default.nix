{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "ipfs-${version}";
  version = "i20160112--${stdenv.lib.strings.substring 0 7 rev}";
  rev = "7070b4d878baad57dcc8da80080dd293aa46cabd";

  goPackagePath = "github.com/ipfs/go-ipfs";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "go-ipfs";
    inherit rev;
    sha256 = "1b7aimnbz287fy7p27v3qdxnz514r5142v3jihqxanbk9g384gcd";
  };

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    license = licenses.mit;
    broken = true;
  };
}
