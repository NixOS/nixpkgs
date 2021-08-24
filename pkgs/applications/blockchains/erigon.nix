{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "erigon";
  version = "2021.08.04";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sw1qr7mdhhmfwdkkyzcjaqs2s3m19d01n3ipzcnqs1iml62rcqr";
  };

  vendorSha256 = "1hschm8xgq52p4s36pp34amcf2fi1kb0clxgkfxr07bsr6z0dn6b";
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
