{ stdenv, lib, go, fetchgit }:

stdenv.mkDerivation rec {
  name = "go-ethereum-${version}";
  version = "1.4.11";
  rev = "refs/tags/v${version}";
  goPackagePath = "github.com/ethereum/go-ethereum";

  buildInputs = [ go ];

  src = fetchgit {
    inherit rev;
    url = "https://${goPackagePath}";
    sha256 = "0lflsx4sx9inb9z2x9qgp98pj623wp9h3c2bjah86zqy42qwwda1";
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
