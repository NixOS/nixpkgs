{ lib, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "go-ethereum-classic-${version}";
  version = "4.0.0";

  goPackagePath = "github.com/ethereumproject/go-ethereum";
  subPackages = [ "cmd/evm" "cmd/geth" ];

  src = fetchgit {
    rev = "v${version}";
    url = "https://github.com/ethereumproject/go-ethereum";
    sha256 = "06f1w7s45q4zva1xjrx92xinsdrixl0m6zhx5hvdjmg3xqcbwr79";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "Golang implementation of Ethereum Classic";
    homepage = https://github.com/ethereumproject/go-ethereum;
    license = with lib.licenses; [ lgpl3 gpl3 ];
    maintainers = with lib.maintainers; [ sorpaas ];
  };
}
