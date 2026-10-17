{ rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "systemd-unit-generator";
  version = "0.1.0";

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  # Don't run tests during build (there are none yet)
  doCheck = false;

  meta = {
    description = "NixOS systemd unit generator written in Rust";
  };
}
