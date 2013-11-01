{ pkgs, ... }:

with pkgs.lib;

{
  options.boot.loader.efi = {
    canTouchEfiVariables = mkOption {
      default = false;

      type = types.bool;

      description = "Whether or not the installation process should modify efi boot variables.";
    };

    efiSysMountPoint = mkOption {
      default = "/boot";

      type = types.string;

      description = "Where the EFI System Partition is mounted.";
    };
  };
}
