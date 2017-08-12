{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "go-ethereum-classic-${version}";
  version = "3.5.0";
  rev = "402c1700fbefb9512e444b32fe12c2d674638ddb";

  goPackagePath = "github.com/ethereumproject/go-ethereum";
  subPackages = [ "cmd/evm" "cmd/geth" ];

  src = fetchgit {
    inherit rev;
    url = "https://github.com/ethereumproject/go-ethereum";
    sha256 = "15wji12wqcrgsb1glwwz4jv7rsas71bbxh7750iv2phn7jivm0fi";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "Golang implementation of Ethereum Classic";
    homepage = https://github.com/ethereumproject/go-ethereum;
    license = with lib.licenses; [ lgpl3 gpl3 ];
  };
}
