{ config, lib, ... }:

with lib;

{
  imports = [
    (mkRenamedOptionModule [ "boot" "loader" "grub" "timeout" ] [ "boot" "loader" "timeout" ])
    (mkRenamedOptionModule [ "boot" "loader" "gummiboot" "timeout" ] [ "boot" "loader" "timeout" ])
  ];

  options = {
    boot.loader = {
      timeout = mkOption {
        default = 5;
        type = types.nullOr types.int;
        description = ''
          Timeout (in seconds) until loader boots the default menu item. Use null if the loader menu should be displayed indefinitely.
        '';
      };
      loadDeviceTree = mkOption {
        default = with config.hardware.deviceTree; enable && name != null;
        defaultText = ''with config.hardware.deviceTree; enable && name != null'';
        description = ''
          Load the devicetree blob specified by `config.hardware.deviceTree.name`
          and instruct bootloader to pass this DTB to linux.
        '';
      };
    };
  };

  config = {
    assertions = [
      {
        assertion =
          config.boot.loader.loadDeviceTree
          -> config.hardware.deviceTree.enable
          -> config.hardware.deviceTree.name != null;
        message = "Cannot load devicetree without 'config.hardware.deviceTree.enable' enabled and 'config.hardware.deviceTree.name' set";
      }
    ];
  };
}
