# blueman service
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.blueman;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "blueman" "withApplet" ]
      [ "services" "blueman" "applet" "enable" ]
    )
  ];
  ###### interface
  options = {
    services.blueman = {
      enable = lib.mkEnableOption "blueman, a bluetooth manager";

      package = lib.mkPackageOption pkgs "blueman" { };
      applet = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to spawn the Blueman tray applet.";
        };

        systemdTargets = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "graphical-session.target" ];
          example = [ "sway-session.target" ];
          description = ''
            The systemd targets that will automatically start the blueman applet service.
          '';
        };
      };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.user.services = {

      # this is a bit awkward: we always want the service definition.
      # If the applet is disabled, the service from the package will be loaded,
      # but the service will not be started on startup, which is fine.
      blueman-applet = lib.mkIf cfg.applet.enable {
        description = "Blueman tray applet";

        wantedBy = cfg.applet.systemdTargets;
        partOf = cfg.applet.systemdTargets;

        serviceConfig = {
          Type = "dbus";
          BusName = "org.blueman.Applet";
          ExecStart = "${cfg.package}/bin/blueman-applet";
          Restart = "on-failure";
        };
      };

      blueman-manager = {
        description = "Bluetooth Manager";

        serviceConfig = {
          Type = "dbus";
          BusName = "org.blueman.Manager";
          ExecStart = "${cfg.package}/bin/blueman-manager";
        };
      };
    };

    systemd.services.blueman-mechanism = {
      description = "Bluetooth management mechanism";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "dbus";
        KillMode = "process";
        BusName = "org.blueman.Mechanism";
        ExecStart = "${cfg.package}/libexec/blueman-mechanism";
      };
    };
  };
}
