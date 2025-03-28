{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.displayManager.aporia;
in
{
  options = {
    services.displayManager.aporia = {
      enable = lib.mkEnableOption "aporia as the display manager";

      package = lib.mkPackageOption pkgs [ "aporia" ] { };

      settings = {
        ascii = {
          name = lib.mkOption {
            description = "Ascii art filename";
            type = lib.types.str;
            default = "default";
          };

          text = lib.mkOption {
            description = "filepath to the ascii art to display in background";
            type = lib.types.nullOr lib.types.lines;
            default = null;
          };
        };

        box-width = lib.mkOption {
          description = "size of the box in the top left";
          type = lib.types.ints.positive;
          default = 50;
        };

        commands = {
          reboot = lib.mkOption {
            description = "reboot commands to use";
            type = lib.types.str;
            default = "/run/current-system/systemd/bin/systemctl reboot";
          };

          shutdown = lib.mkOption {
            description = "shutdown commands to use";
            type = lib.types.str;
            default = "/run/current-system/systemd/bin/systemctl poweroff";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security.pam.services.aporia = {
      startSession = true;
      unixAuth = true;
    };

    environment = lib.mkMerge [
      (
        let
          session-prefix = config.services.displayManager.sessionData.desktops;
        in
        {
          etc."aporia/config".text =
            (lib.optionalString (cfg.settings.ascii.text != null) ''
              # Ascii is the name of the ascii file to use
              ascii = ${cfg.settings.ascii.name}
            '')
            + ''
              # The size of the box in the top left.
              # Warning: values lower than 35 will not display properly.
              box_width = ${builtins.toString cfg.settings.box-width}

              # The shutdown and reboot commands to use
              shutdown_command = ${cfg.settings.commands.shutdown}
              reboot_command = ${cfg.settings.commands.reboot}

              # The paths to search for desktop files
              xsessions_path = "${session-prefix}/share/xsessions
              wayland_sessions_path = ${session-prefix}/share/wayland-sessions
            '';

          pathsToLink = [ "/share/aporia" ];
          systemPackages = [ cfg.package ];
        }
      )
      (lib.mkIf (cfg.settings.ascii.text != null) {
        etc."aporia/${cfg.settings.ascii.name}.ascii".text = cfg.settings.ascii.text;
      })
    ];

    services = {
      dbus.packages = [ cfg.package ];

      displayManager = {
        enable = true;
        execCmd = "exec /run/current-system/sw/bin/aporia";
      };

      xserver = lib.mkIf config.services.xserver.enable {
        tty = null;
        display = null;
      };
    };

    systemd.services.display-manager = {
      after = [
        "systemd-user-sessions.service"
        "plymouth-quit-wait.service"
      ];

      conflicts = [ "getty@tty1.service" ];

      serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        TTYPath = "/dev/tty1";
        TTYReset = "yes";
        TTYVHangup = "yes";
      };
    };
  };
}
