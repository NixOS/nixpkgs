{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "turbo-geth";
  version = "2021.05.02";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7sTRAAlKZOdwi/LRbIEDKWpBe1ol8pZfEf2KIC4s0xk=";
  };

  vendorSha256 = "1d0ahdb2b5v8nxq3kdxw151phnyv6habb8kr8qjaq3kyhcnyk6ng";
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
    maintainers = with maintainers; [ d-xo ];
  };
}
