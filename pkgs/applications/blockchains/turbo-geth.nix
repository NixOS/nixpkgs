{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "turbo-geth";
  version = "2021.04.05";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RTPNJASNFyZ6tDJj0WOqALyxRsOLJzPy0qA1c2sSxys=";
  };

  vendorSha256 = "01c7lb6n00ws60dfybir0z5dbn6h68p5s4hbq0ga2g7drf3l3y0p";
  runVend = true;

  subPackages = [
    "cmd/tg"
    "cmd/evm"
    "cmd/rpcdaemon"
    "cmd/rlpdump"
  ];

  meta = with lib; {
    homepage = "https://github.com/ledgerwatch/turbo-geth/";
    description = "Ethereum node and geth fork focused on scalability and modularity";
    license = with licenses; [ lgpl3Plus gpl3Plus ];
    maintainers = with maintainers; [ xwvvvvwx ];
  };
}
