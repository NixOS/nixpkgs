{ config, lib, pkgs, ... }:
{
  options = {
    oci = {
      efi = lib.mkOption {
        default = true;
        internal = true;
        description = ''
          Whether the OCI instance is using EFI.
        '';
      };
    };
  };
}
