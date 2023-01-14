{ lib, rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "format-maintainer-list";
  version = (lib.importTOML ./Cargo.toml).package.version;

  src = lib.cleanSource ./.;

  cargoLock.lockFile = ./Cargo.lock;
}
