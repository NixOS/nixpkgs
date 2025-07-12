/**
  Returns a list of tests for a given list of NixOS module files (and/or other files which will be ignored).

  This is a convenience wrapper for use with `nix-build`.

  A more detailed structure than a list is available in the `meta.tests` option value.

  Example usage (to be run from the Nixpkgs root):
    nix-build maintainers/scripts/nixos-tests-for-files.nix --arg files '[ ./nixos/modules/security/acme ]'
*/
{
  files,
  system ? builtins.currentSystem,
# NOTE: if you need finer control, you are encouraged to use `config.meta.tests` directly
}:

let
  pkgs = import ../.. {
    config = { };
    overlays = [ ];
    inherit system;
  };
  sample = pkgs.nixos {
    imports = [ ../../nixos/modules/virtualisation/qemu-vm.nix ];
  };
in
# See nixos/modules/misc/meta.nix or :doc on an evaluated NixOS
sample.config.meta.tests.filterForNixBuild files
