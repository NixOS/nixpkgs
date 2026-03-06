{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.nm-applet;
in
{
  meta = {
    maintainers = lib.teams.freedesktop.members;
  };

  options.programs.nm-applet = {
    enable = lib.mkEnableOption "nm-applet, a NetworkManager control applet for GNOME";

    indicator = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to use indicator instead of status icon.
        It is needed for Appindicator environments, like Enlightenment.
      '';
    };

    package = lib.mkPackageOption pkgs "networkmanagerapplet" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.user.services.nm-applet = {
      description = "Network manager applet";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${cfg.package}/bin/nm-applet ${lib.optionalString cfg.indicator "--indicator"}";
    };

    services.dbus.packages = [ pkgs.gcr ];
  };
}
