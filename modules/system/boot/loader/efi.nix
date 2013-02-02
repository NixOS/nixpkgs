{ pkgs, ... }:

with pkgs.lib;

{
  options.boot.loader.efi = {
    efibootmgr = {
      efiDisk = mkOption {
        default = "/dev/sda";

        type = types.string;

        description = "The disk that contains the EFI system partition.";
      };

      enable = mkOption {
        default = false;

        type = types.bool;

        description = ''
          Whether to run efibootmgr to add the efi bootloaders configuration to the boot options list.
          WARNING! efibootmgr has been rumored to brick Apple firmware on
          old kernels! Don't use it on kernels older than 2.6.39!
        '';
      };

      efiPartition = mkOption {
        default = "1";
        description = "The partition number of the EFI system partition.";
      };

      postEfiBootMgrCommands = mkOption {
        default = "";
        type = types.string;
        description = ''
          Shell commands to be executed immediately after efibootmgr has setup the system EFI.
          Some systems do not follow the EFI specifications properly and insert extra entries.
          Others will brick (fix by removing battery) on boot when it finds more than X entries.
          This hook allows for running a few extra efibootmgr commands to combat these issues.
        '';
      };
    };

    efiSysMountPoint = mkOption {
      default = "/boot";

      type = types.string;

      description = "Where the EFI System Partition is mounted.";
    };
  };
}
