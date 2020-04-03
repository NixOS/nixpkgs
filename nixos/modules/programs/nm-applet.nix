{ config, lib, pkgs, ... }:

{
  meta = {
    maintainers = lib.teams.freedesktop.members;
  };

  options.programs.nm-applet.enable = lib.mkEnableOption "nm-applet";

  config = lib.mkIf config.programs.nm-applet.enable {
    systemd.user.services.nm-applet = {
      description = "Network manager applet";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
    };

    services.dbus.packages = [ pkgs.gcr ];
  };
}
