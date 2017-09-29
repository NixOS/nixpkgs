{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "go-ethereum-classic-${version}";
  version = "3.5.86";

  goPackagePath = "github.com/ethereumproject/go-ethereum";
  subPackages = [ "cmd/evm" "cmd/geth" ];

  src = fetchgit {
    rev = "v${version}";
    url = "https://github.com/ethereumproject/go-ethereum";
    sha256 = "1k59hl3qvx4422zqlp259566fnxq5bs67jhm0v6a1zfr1k8iqzwh";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "Golang implementation of Ethereum Classic";
    homepage = https://github.com/ethereumproject/go-ethereum;
    license = with lib.licenses; [ lgpl3 gpl3 ];
    maintainers = with lib.maintainers; [ sorpaas ];
  };
}
