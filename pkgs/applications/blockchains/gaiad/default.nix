{ lib, stdenv, buildGoModule, fetchzip, nixosTests }:

let
  bins = [
    "gaiad"
  ];

in
buildGoModule rec {
  pname = "gaia";
  version = "7.1.0";

  src = fetchzip {
    url = "https://github.com/cosmos/${pname}/archive/refs/tags/v${version}.zip";
    sha256 = "sha256-hsDqDASwTPIb1BGOqa9nu4C5Y5q3hBoXYhkAFY7B9Cs=";
  };

  vendorSha256 = "sha256-bNeSSZ1n1fEvO9ITGGJzsc+S2QE7EoB703mPHzrEqAg=";

  doCheck = false;

  enableParallelBuilding = true;

  outputs = [ "out" ];

  meta = with lib; {
    description = "Stargate Cosmos Hub App";
    longDescription = "The Gaia Daemon (`sgaiad`) enables you to interact with the Cosmos Hub, the first of an exploding number of interconnected blockchains that comprise the Cosmos Network.";
    homepage    = "https://hub.cosmos.network";
    license     = licenses.asl20;
    maintainers = with maintainers; [ jovalie ];
  };

}
