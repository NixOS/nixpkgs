{ lib, rustPlatform }:
let
  fs = lib.fileset;
in
rustPlatform.buildRustPackage {
  pname = "basic-dynamic";
  version = "0.1.0";

  src = fs.toSource {
    root = ./.;
    fileset = fs.unions [
      ./Cargo.toml
      ./Cargo.lock
      ./src
    ];
  };

  cargoLock.lockFileContents = builtins.readFile ./Cargo.lock;

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/basic-dynamic
  '';
}
