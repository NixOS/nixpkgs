{ stdenv, lib, go, fetchgit }:

stdenv.mkDerivation rec {
  name = "go-ethereum-${version}";
  version = "1.4.7";
  rev = "refs/tags/v${version}";
  goPackagePath = "github.com/ethereum/go-ethereum";

  buildInputs = [ go ];

  src = fetchgit {
    inherit rev;
    url = "https://${goPackagePath}";
    sha256 = "19q518kxkvrr44cvsph4wv3lr6ivqsckz1f22r62932s3sq6gyd8";
  };

  buildPhase = ''
    export GOROOT=$(mktemp -d --suffix=-goroot)
    ln -sv ${go}/share/go/* $GOROOT
    ln -svf ${go}/bin $GOROOT
    make all
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -v build/bin/* $out/bin
  '';

  meta = {
    homepage = "https://ethereum.github.io/go-ethereum/";
    description = "Official golang implementation of the Ethereum protocol";
    license = with lib.licenses; [ lgpl3 gpl3 ];
  };
}
