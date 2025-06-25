{
  config,
  lib,
  pkgs,
  ...
}:

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
  };

  config = lib.mkIf config.programs.nm-applet.enable {
    systemd.user.services.nm-applet = {
      description = "Network manager applet";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet ${lib.optionalString config.programs.nm-applet.indicator "--indicator"}";
    };

    services.dbus.packages = [ pkgs.gcr ];
  };
}
