{
  lib,
  rustPlatform,
}:
let
  cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
in
{
  file-structure-transformer-vendor = rustPlatform.buildRustPackage {
    pname = cargoToml.package.name;
    inherit (cargoToml.package) version;

    src = lib.fileset.toSource {
      root = ./.;
      fileset = lib.fileset.unions [
        ./src
        ./Cargo.lock
        ./Cargo.toml
      ];
    };
    cargoLock.lockFile = ./Cargo.lock;
  };
}
