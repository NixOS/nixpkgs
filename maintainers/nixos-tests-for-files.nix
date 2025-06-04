/**
  Returns a list of tests for a given list of NixOS module files (and/or other files which will be ignored).

  A more detailed structure than a list is available in the `meta.tests` option value.

  Example:
    nix-build maintainers/nixos-tests-for-files.nix --arg files '[ nixos/modules/services/databases/postgresql.nix ]'
*/
{
  files,
  system ? builtins.currentSystem,
}:

let
  pkgs = import ../. {
    config = { };
    overlays = [ ];
    inherit system;
  };
  sample = pkgs.nixos {
    imports = [ ../nixos/modules/virtualisation/qemu-vm.nix ];
  };
in
# See nixos/modules/misc/meta.nix or :doc on an evaluated NixOS
sample.config.meta.tests.filterForNixBuild files
