# Deprecated alias of `./oracle-cloud-infra-common.nix`.
# "OCI" also refers to the Open Container Initiative, see `./oci-containers.nix`.
{ lib, ... }:
{
  imports = [ ./oracle-cloud-infra-common.nix ];

  warnings = lib.optional (lib.oldestSupportedReleaseIsAtLeast 2611) ''
    The module <nixpkgs/nixos/modules/virtualisation/oci-common.nix> was renamed to
    <nixpkgs/nixos/modules/virtualisation/oracle-cloud-infra-common.nix>.
    Update the imports of your configuration.
  '';
}
