{
  lib,
  rustPlatform,
  ...
}:
let
  metadata = builtins.fromTOML (builtins.readFile ./Cargo.toml);
  src = let fs = lib.fileset; in fs.toSource {
    root = ./.;
    fileset = fs.unions [
      ./Cargo.lock
      ./Cargo.toml
      ./src
    ];
  };
in rustPlatform.buildRustPackage {
  inherit src;

  pname = metadata.package.name;
  version = metadata.package.version;

  cargoLock.lockFile = ./Cargo.lock;

  meta = {
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.jlamur ];
  };
}
