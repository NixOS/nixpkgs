{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "erigon";
  version = "2021.09.04";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l0w1badhvlh1rgqzvlmy5k7xhb1nf4f5dmhkl935a5ila08aak3";
  };

  vendorSha256 = "1hbfmq76zm50zwmlh3jblriwq2k1mp99d8lg8xzxwy56hncgfj8k";
  runVend = true;

  # Build errors in mdbx when format hardening is enabled:
  #   cc1: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  subPackages = [
    "cmd/erigon"
    "cmd/evm"
    "cmd/rpcdaemon"
    "cmd/rlpdump"
  ];

  meta = with lib; {
    homepage = "https://github.com/ledgerwatch/erigon/";
    description = "Ethereum node implementation focused on scalability and modularity";
    license = with licenses; [ lgpl3Plus gpl3Plus ];
    maintainers = with maintainers; [ d-xo ];
  };
}
