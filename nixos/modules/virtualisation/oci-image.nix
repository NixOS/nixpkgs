# Deprecated alias of `./oracle-cloud-infra-image.nix`.
# "OCI" also refers to the Open Container Initiative, see `./oci-containers.nix`.
{ lib, ... }:
{
  imports = [ ./oracle-cloud-infra-image.nix ];

  warnings = lib.optional (lib.oldestSupportedReleaseIsAtLeast 2611) ''
    The module <nixpkgs/nixos/modules/virtualisation/oci-image.nix> was renamed to
    <nixpkgs/nixos/modules/virtualisation/oracle-cloud-infra-image.nix>.
    Update the imports of your configuration.
  '';
}
