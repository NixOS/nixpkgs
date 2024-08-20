# A module containing the base imports and overrides that
# are always applied in NixOS VM tests, unconditionally,
# even in `inheritParentConfig = false` specialisations.
{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  imports = [
    ../../modules/virtualisation/qemu-vm.nix
    ../../modules/testing/test-instrumentation.nix # !!! should only get added for automated test runs
    { key = "no-manual"; documentation.nixos.enable = false; }
    {
      key = "no-revision";
      # Make the revision metadata constant, in order to avoid needless retesting.
      # The human version (e.g. 21.05-pre) is left as is, because it is useful
      # for external modules that test with e.g. testers.nixosTest and rely on that
      # version number.
      config.system.nixos = {
        revision = mkForce "constant-nixos-revision";
        versionSuffix = mkForce "test";
        label = mkForce "test";
      };
    }

  ];
}
