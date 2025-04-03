{
  config,
  lib,
  pkgs,
  ...
}:
{

  options.services.paretosecurity = {
    enable = lib.mkEnableOption "[ParetoSecurity](https://paretosecurity.com) [agent](https://github.com/ParetoSecurity/agent) and its root helper";
    package = lib.mkPackageOption pkgs "paretosecurity" { };
    trayIcon = lib.mkEnableOption "tray icon for ParetoSecurity";
  };

  config = lib.mkIf config.services.paretosecurity.enable {
    environment.systemPackages = [ config.services.paretosecurity.package ];
    systemd.packages = [ config.services.paretosecurity.package ];

    # In traditional Linux distributions, systemd would read the [Install] section from
    # unit files and automatically create the appropriate symlinks to enable services.
    # However, in NixOS, due to its immutable nature and the way the Nix store works,
    # the [Install] sections are not processed during system activation. Instead, we
    # must explicitly tell NixOS which units to enable by specifying their target
    # dependencies here. This creates the necessary symlinks in the proper locations.
    systemd.sockets.paretosecurity.wantedBy = [ "sockets.target" ];

    # Enable the tray icon and timer services if the trayIcon option is enabled
    systemd.user = lib.mkIf config.services.paretosecurity.trayIcon {
      services.paretosecurity-trayicon = {
        wantedBy = [ "graphical-session.target" ];
      };
      services.paretosecurity-user = {
        wantedBy = [ "graphical-session.target" ];
      };
      timers.paretosecurity-user = {
        wantedBy = [ "timers.target" ];
      };
    };
  };
}
