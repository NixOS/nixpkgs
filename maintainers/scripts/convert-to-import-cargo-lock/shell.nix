{
  convert-to-import-cargo-lock ? import ./default.nix { },
}:
convert-to-import-cargo-lock.shell
