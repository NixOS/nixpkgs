{ config, lib, pkgs, ... }:
{
  options = {
    oci = {
      efi = lib.mkOption {
        default = pkgs.stdenv.hostPlatform.isAarch64;
        internal = true;
        description = ''
          Whether the OCI instance is using EFI.
        '';
      };
    };
  };
}
