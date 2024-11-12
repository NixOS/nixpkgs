{
  lib,
  rustPlatform,
}:

let
  cargo = lib.importTOML ./src/Cargo.toml;
in
rustPlatform.buildRustPackage {
  pname = cargo.package.name;
  version = cargo.package.version;

  src = ./src;

  cargoLock.lockFile = ./src/Cargo.lock;

  meta = {
    description = "Output a path's realpath within a chroot.";
    maintainers = [ lib.maintainers.elvishjerricco ];
  };
}
