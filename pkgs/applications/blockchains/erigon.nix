{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "erigon";
  version = "2022.09.01";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vcppzHJ6yLIqp/5Gl9JIgkTVR1mKKAj1vhWY/bCvbPQ=";
    fetchSubmodules = true;
  };

  vendorSha256 = "sha256-mY8m5bXm09pmq1imCo8uiBBnzPzrVuka8XtZyxL9LWo=";
  proxyVendor = true;

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
