{ lib, rustPlatform }:
let
  fs = lib.fileset;
in
rustPlatform.buildRustPackage {
  pname = "git-dependency-branch";
  version = "0.1.0";

  src = fs.toSource {
    root = ./.;
    fileset = fs.unions [
      ./Cargo.toml
      ./Cargo.lock
      ./src
    ];
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rand-0.8.4" = "1ilk9wvfw3mdm57g199ys8f5nrgdrh0n3a4c8b7nz6lgnqvfrv6z";
    };
  };

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/git-dependency-branch
  '';
}
