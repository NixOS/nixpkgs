{ config, lib, ... }:
{
  options.boot.loader.efi = {

    canTouchEfiVariables = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether the installation process is allowed to modify EFI boot variables.";
    };

    efiSysMountPoint = lib.mkOption {
      default = "/boot";
      type = lib.types.str;
      description = "Where the EFI System Partition is mounted.";
    };

    installDeviceTree = lib.mkOption {
      default = with config.hardware.deviceTree; enable && name != null;
      defaultText = ''with config.hardware.deviceTree; enable && name != null'';
      description = ''
        Install the devicetree blob specified by `config.hardware.deviceTree.name`
        to the ESP and instruct the bootloader to pass this DTB to linux.
      '';
    };
  };
}
