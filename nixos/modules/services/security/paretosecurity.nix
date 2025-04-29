{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.paretosecurity;
in
{

  options.services.paretosecurity = {
    enable = lib.mkEnableOption "[ParetoSecurity](https://paretosecurity.com) [agent](https://github.com/ParetoSecurity/agent) and its root helper";
    package = lib.mkPackageOption pkgs "paretosecurity" { };
    trayIcon = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set to false to disable the tray icon and run as a CLI tool only.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    # In traditional Linux distributions, systemd would read the [Install] section from
    # unit files and automatically create the appropriate symlinks to enable services.
    # However, in NixOS, due to its immutable nature and the way the Nix store works,
    # the [Install] sections are not processed during system activation. Instead, we
    # must explicitly tell NixOS which units to enable by specifying their target
    # dependencies here. This creates the necessary symlinks in the proper locations.
    systemd.sockets.paretosecurity.wantedBy = [ "sockets.target" ];

    # In NixOS, systemd services are configured with minimal PATH. However,
    # paretosecurity helper looks for installed software to do its job, so
    # it needs the full system PATH. For example, it runs `iptables` to see if
    # firewall is configured. And it looks for various password managers to see
    # if one is installed.
    # The `paretosecurity-user` timer service that is configured lower has
    # the same need.
    systemd.services.paretosecurity.serviceConfig.Environment = [
      "PATH=${config.system.path}/bin:${config.system.path}/sbin"
    ];

    # Enable the tray icon and timer services if the trayIcon option is enabled
    systemd.user = lib.mkIf cfg.trayIcon {
      services = {
        paretosecurity-trayicon.wantedBy = [ "graphical-session.target" ];
        paretosecurity-user = {
          wantedBy = [ "graphical-session.target" ];
          serviceConfig.Environment = [
            "PATH=${config.system.path}/bin:${config.system.path}/sbin"
          ];
        };
      };
      timers.paretosecurity-user.wantedBy = [ "timers.target" ];
    };
  };
}
