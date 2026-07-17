{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.rumno;
in
{
  meta.maintainers = with lib.maintainers; [ imalison ];

  options.services.rumno = {
    enable = lib.mkEnableOption "rumno visual pop-up notification manager";

    package = lib.mkPackageOption pkgs "rumno" { };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--verbose"
        "--config"
        "/etc/rumno/config.toml"
      ];
      description = ''
        Extra command-line arguments to pass to the rumno daemon.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.rumno = {
      description = "Rumno visual pop-up notification manager";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session-pre.target" ];

      serviceConfig = {
        Type = "dbus";
        BusName = "de.rumno.v1";
        ExecStart = "${cfg.package}/bin/rumno daemon --foreground ${lib.escapeShellArgs cfg.extraArgs}";
        Restart = "on-failure";
        RestartSec = 1;

        # Environment for GTK/GUI applications
        PassEnvironment = [
          "DISPLAY"
          "WAYLAND_DISPLAY"
          "XDG_RUNTIME_DIR"
        ];
      };

      environment = {
        # Set GTK theme environment variables if needed
        GTK_THEME = lib.mkDefault "";
      };
    };

    # Ensure dbus service file is installed
    environment.systemPackages = [ cfg.package ];
  };
}
