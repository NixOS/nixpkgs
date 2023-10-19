{ lib, buildGoModule, fetchFromGitHub, nix-update-script }:

let
  pname = "erigon";
  version = "2.50.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gZ01nmxzXRK8YRwnl5qGkU6dqBYKPUkNZmbClwgsuL0=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-4s5dXTfYlgzYQ2h30F6kxEF626iKYFRoZlNXeFDbn8s=";
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/ledgerwatch/erigon/";
    description = "Ethereum node implementation focused on scalability and modularity";
    license = with licenses; [ lgpl3Plus gpl3Plus ];
    maintainers = with maintainers; [ d-xo happysalada ];
  };
}
