{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.opentabletdriver;
in
{
  meta.maintainers = with lib.maintainers; [
    gepbird
    thiagokokada
  ];

  options = {
    hardware.opentabletdriver = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable OpenTabletDriver udev rules, user service and blacklist kernel
          modules known to conflict with OpenTabletDriver.
        '';
      };

      blacklistedKernelModules = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "hid-uclogic"
          "wacom"
        ];
        description = ''
          Blacklist of kernel modules known to conflict with OpenTabletDriver.
        '';
      };

      package = lib.mkPackageOption pkgs "opentabletdriver" { };

      daemon = {
        enable = lib.mkOption {
          default = true;
          type = lib.types.bool;
          description = ''
            Whether to start OpenTabletDriver daemon as a systemd user service.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    boot.blacklistedKernelModules = cfg.blacklistedKernelModules;

    systemd.user.services.opentabletdriver = lib.mkIf cfg.daemon.enable {
      description = "Open source, cross-platform, user-mode tablet driver";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      unitConfig = {
        After = "graphical-session.target";
        ConditionEnvironment = [
          "|WAYLAND_DISPLAY"
          "|DISPLAY"
        ];
      };

      serviceConfig = {
        Type = "simple";
        # workaround for https://github.com/NixOS/nixpkgs/issues/469340 and
        # https://github.com/OpenTabletDriver/OpenTabletDriver/issues/4885
        ExecStartPre = pkgs.writeShellScript "poll-for-non-gdm-greeter-display" ''
          if [[ "$USER" = "gdm-greeter"* \
              || ( "$${XDG_SESSION_TYPE}" = wayland && -z "$${WAYLAND_DISPLAY}" ) ]]; then
            exit 1
          fi
        '';
        ExecStart = lib.getExe' cfg.package "otd-daemon";
        Restart = "on-failure";
        RestartSec = 3;
      };
    };
  };
}
