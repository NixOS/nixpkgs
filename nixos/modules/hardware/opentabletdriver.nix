{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.opentabletdriver;
in
{
  meta.maintainers = with lib.maintainers; [ thiagokokada ];

  options = {
    hardware.opentabletdriver = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable OpenTabletDriver udev rules, user service and blacklist kernel
          modules known to conflict with OpenTabletDriver.
        '';
      };

      blacklistedKernelModules = mkOption {
        type = types.listOf types.str;
        default = [ "hid-uclogic" "wacom" ];
        description = lib.mdDoc ''
          Blacklist of kernel modules known to conflict with OpenTabletDriver.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.opentabletdriver;
        defaultText = literalExpression "pkgs.opentabletdriver";
        description = lib.mdDoc ''
          OpenTabletDriver derivation to use.
        '';
      };

      daemon = {
        enable = mkOption {
          default = true;
          type = types.bool;
          description = lib.mdDoc ''
            Whether to start OpenTabletDriver daemon as a systemd user service.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    boot.blacklistedKernelModules = cfg.blacklistedKernelModules;

    systemd.user.services.opentabletdriver = with pkgs; mkIf cfg.daemon.enable {
      description = "Open source, cross-platform, user-mode tablet driver";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/otd-daemon -c ${cfg.package}/lib/OpenTabletDriver/Configurations";
        Restart = "on-failure";
      };
    };
  };
}
