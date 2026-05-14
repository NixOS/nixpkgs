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
  ###### interface
  options = {
    services.blueman = {
      enable = lib.mkEnableOption "blueman, a bluetooth manager";

      withApplet = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to spawn the Blueman tray applet.";
      };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.blueman ];

    services.dbus.packages = [ pkgs.blueman ];

    systemd.packages = [ pkgs.blueman ];

    systemd.user.services.blueman-applet = lib.mkIf cfg.withApplet {
      description = "Blueman tray applet";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.blueman}/bin/blueman-applet";
        Restart = "on-failure";
      };
    };
  };
}
