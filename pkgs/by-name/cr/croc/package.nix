{
  lib,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  nixosTests,
}:

buildGoModule rec {
  pname = "croc";
  version = "10.1.1";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+60s0NMSXRUlYDdoxPeEZYx1EMfMODNA/A7rkje5x7o=";
  };

  vendorHash = "sha256-/cTYfGpGbtPvIwriqemDatcMf+cP76eD6OV0oGQenAk=";

  subPackages = [ "." ];

  passthru = {
    tests = {
      local-relay = callPackage ./test-local-relay.nix { };
      inherit (nixosTests) croc;
    };
  };

  meta = with lib; {
    description = "Easily and securely send things from one computer to another";
    longDescription = ''
      Croc is a command line tool written in Go that allows any two computers to
      simply and securely transfer files and folders.

      Croc does all of the following:
      - Allows any two computers to transfer data (using a relay)
      - Provides end-to-end encryption (using PAKE)
      - Enables easy cross-platform transfers (Windows, Linux, Mac)
      - Allows multiple file transfers
      - Allows resuming transfers that are interrupted
      - Does not require a server or port-forwarding
    '';
    homepage = "https://github.com/schollz/croc";
    license = licenses.mit;
    maintainers = with maintainers; [
      equirosa
      SuperSandro2000
    ];
    mainProgram = "croc";
  };
}
