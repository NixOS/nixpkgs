{ lib, buildGoModule, fetchFromGitHub, nix-update-script }:

let
  pname = "erigon";
  version = "2.39.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HlAnuc6n/de6EzHTit3xGCFLrc2+S+H/o0gCxH8d0aU=";
    fetchSubmodules = true;
  };

  vendorSha256 = "sha256-kKwaA6NjRdg97tTEzEI+TWMSx7izzFWcefR5B086cUY=";
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
