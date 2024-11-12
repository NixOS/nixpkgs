{ lib, rustPlatform }:
let
  fs = lib.fileset;
in
rustPlatform.buildRustPackage {
  pname = "git-dependency-rev";
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
      "rand-0.8.3" = "0l3p174bpwia61vcvxz5mw65a13ri3wy94z04xrnyy5lzciykz4f";
    };
  };

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/git-dependency-rev
  '';
}
