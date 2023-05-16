{ lib, buildGoModule, fetchFromGitHub, nix-update-script }:

let
  pname = "erigon";
<<<<<<< HEAD
  version = "2.48.1";
=======
  version = "2.43.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ApVsrK1Di6d3WBj/VIUcYJBceFDTeNfsXYPRfbytvZg=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-bsPeEAhvuT5GIpYMoyPyh0BHMDKyKjBiVnYLjtF4Mkc=";
=======
    sha256 = "sha256-3o7vu2bA8lB1CiVaSF6YU9WjwNliQAK5AcGl82GCqFg=";
    fetchSubmodules = true;
  };

  vendorSha256 = "sha256-JhMefeUxo9ksyCnNsLgAhGG0Ix7kxCA/cYyiELd0H64=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
