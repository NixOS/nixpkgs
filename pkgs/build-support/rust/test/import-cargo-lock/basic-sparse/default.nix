{ lib, rustPlatform }:
let
  fs = lib.fileset;
in
rustPlatform.buildRustPackage {
  pname = "basic-sparse";
  version = "0.1.0";

  src = fs.toSource {
    root = ./.;
    fileset = fs.unions [
      ./.cargo/config.toml
      ./Cargo.toml
      ./Cargo.lock
      ./src
    ];
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    extraRegistries = {
        "sparse+https://index.crates.io/" = "https://static.crates.io/crates";
    };
  };

  doInstallCheck = true;
  postConfigure = ''
    cargo metadata --offline
  '';
  installCheckPhase = ''
    $out/bin/basic-sparse
  '';
}
