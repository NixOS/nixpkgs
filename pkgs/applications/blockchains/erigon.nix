{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "erigon";
  version = "2022.02.03";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-M8rCLkKoCx+5Eg53HfK6Ui4UrYsujGd7G8ckONclhTM=";
  };

  vendorSha256 = "sha256-loYo1nAR1lARsfoY5Q+k/tgVBxNxcr++zwUjLN3TRLA=";
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
