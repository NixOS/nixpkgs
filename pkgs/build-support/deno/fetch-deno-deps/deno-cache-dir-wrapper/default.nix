{
  lib,
  rustPlatform,
}:
let
  cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
in
{
  deno-cache-dir-wrapper = rustPlatform.buildRustPackage {
    pname = cargoToml.package.name;
    inherit (cargoToml.package) version;

    src = lib.sourceFilesBySuffices ./. [
      ".rs"
      ".toml"
      ".lock"
    ];
    cargoLock.lockFile = ./Cargo.lock;
  };
}
