{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hardware.nitrokey;

in

{
  options.hardware.nitrokey = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables udev rules for Nitrokey devices. By default grants access
        to users in the "nitrokey" group. You may want to install the
        nitrokey-app package, depending on your device and needs.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "nitrokey";
      example = "wheel";
      description = ''
        Grant access to Nitrokey devices to users in this group.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [
      (pkgs.nitrokey-udev-rules.override (attrs:
        { inherit (cfg) group; }
      ))
    ];
    users.extraGroups."${cfg.group}" = {};
  };
}
