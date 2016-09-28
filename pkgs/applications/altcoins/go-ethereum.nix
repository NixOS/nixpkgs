{ stdenv, lib, go, fetchgit }:

stdenv.mkDerivation rec {
  name = "go-ethereum-${version}";
  version = "1.4.13";
  rev = "refs/tags/v${version}";
  goPackagePath = "github.com/ethereum/go-ethereum";

  buildInputs = [ go ];

  src = fetchgit {
    inherit rev;
    url = "https://${goPackagePath}";
    sha256 = "1z627c0kbrddy9j670fhkhsj4k11risbfyfv4wbgr6lvwv5agqsq";
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

  meta = with stdenv.lib; {
    description = "Official golang implementation of the Ethereum protocol";
    homepage = "https://ethereum.github.io/go-ethereum/";
    maintainers = with maintainers; [ ryepdx ];
    license = with lib.licenses; [ lgpl3 gpl3 ];
    platforms = platforms.linux;
  };
}
