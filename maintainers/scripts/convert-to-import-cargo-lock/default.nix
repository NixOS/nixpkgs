with import ../../../. { };

rustPlatform.buildRustPackage {
  name = "convert-to-import-cargo-lock";

  src = lib.cleanSourceWith {
    src = ./.;
    filter =
      name: type:
      let
        name' = baseNameOf name;
      in
      name' != "default.nix" && name' != "target";
  };

  cargoLock.lockFile = ./Cargo.lock;
}
