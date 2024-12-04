{ lib, buildGoModule, fetchFromGitHub, callPackage, nixosTests }:

buildGoModule rec {
  pname = "croc";
  version = "10.1.0";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xHvFs5j4icsGJsmXGg+WCQRTIx5I6ixEgRqKiYwAZio=";
  };

  vendorHash = "sha256-xTXWy8L+i3XbsnFqtSU6B/3e5zEXLjIAyKO7zslcr9o=";

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
    maintainers = with maintainers; [ equirosa SuperSandro2000 ];
    mainProgram = "croc";
  };
}
