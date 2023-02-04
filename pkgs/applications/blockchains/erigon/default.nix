{ lib, buildGoModule, fetchFromGitHub, nix-update-script }:

let
  pname = "erigon";
  version = "2.37.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r/mumt/f0wrOsXyEHo/NX0lJGt8zqXEVNC+9DWDkHAM=";
    fetchSubmodules = true;
  };

  vendorSha256 = "sha256-vSJZ1wIx1CiLE04ZBDnQDQqM2v8BBLxw5qbAsixC3/U=";
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
