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

  useFetchCargoVendor = true;
  cargoHash = "sha256-W3Hpeuw+rMY5uXS87h9P2tae3fOSjriztehTrbfnjZE=";

  meta = {
    description = "Output a path's realpath within a chroot.";
    maintainers = [ lib.maintainers.elvishjerricco ];
  };
}
