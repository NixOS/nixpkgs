{
  config,
  lib,
  pkgs,
  ...
}:
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
      diskSize = lib.mkOption {
        type = lib.types.int;
        default = 8192;
        description = "Size of the disk image created in MB.";
        example = "diskSize = 12 * 1024; # 12GiB";
      };
    };
  };
}
