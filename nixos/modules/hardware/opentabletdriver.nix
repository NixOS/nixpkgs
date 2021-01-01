{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.opentabletdriver;
in
{
  options = {
    hardware.opentabletdriver = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable OpenTabletDriver udev rules, user service and blacklist kernel
          modules known to conflict with OpenTabletDriver.
        '';
      };

      blacklistedKernelModules = mkOption {
        type = types.listOf types.str;
        default = [ "hid-uclogic" "wacom" ];
        description = ''
          Blacklist of kernel modules known to conflict with OpenTabletDriver.
        '';
      };

      daemon = {
        enable = mkOption {
          default = true;
          type = types.bool;
          description = ''
            Whether to start OpenTabletDriver daemon as a systemd user service.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ opentabletdriver ];

    services.udev.packages = with pkgs; [ opentabletdriver ];

    boot.blacklistedKernelModules = cfg.blacklistedKernelModules;

    systemd.user.services.opentabletdriver = with pkgs; mkIf cfg.daemon.enable {
      description = "Open source, cross-platform, user-mode tablet driver";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${opentabletdriver}/bin/otd-daemon -c ${opentabletdriver}/lib/OpenTabletDriver/Configurations";
        Restart = "on-failure";
      };
    };
  };
}
