{
  imports,
  lib,
  self,
}:
let
  flakeVersionInfoOverlay = (import ./flake-version-info.nix self);
in
{
  # The `lib` flake output is the [Nixpkgs library](https://nixos.org/manual/nixpkgs/unstable/#id-1.4)
  # extended with some additional attributes. Those are defined in other flake modules, such as the NixOS one.
  #
  # DON'T USE `lib.extend` TO ADD NEW FUNCTIONALITY.
  # THIS WAS A MISTAKE. See the warning in `./default.nix`.
  outputs.lib = lib.foldl (cur: overlay: cur.extend overlay) lib [
    flakeVersionInfoOverlay
    imports.nixos.libOverlay
  ];
}
