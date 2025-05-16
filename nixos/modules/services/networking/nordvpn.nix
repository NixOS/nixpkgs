{
  config,
  lib,
  pkgs,
  proc-ps,
  ...
}:

let
  cfg = config.services.nordvpn;
  nordvpnPkg = cfg.package;
in

{
  options.services.nordvpn = {
    enable = lib.mkEnableOption "Enable NordVPN";
    package = lib.mkPackageOption pkgs "nordvpn" { };
  };

  config = lib.mkIf cfg.enable {

    users.groups.nordvpn = { };

    users.users.nordvpn = {
      group = "nordvpn";
      isSystemUser = true;
    };

    services.resolved.enable = true;

    security.polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.resolve1.set-dns-servers"
              && subject.isInGroup("nordvpn")) {
            return polkit.Result.YES;
          }
        });
      '';
    };

    services.dbus.packages = [ nordvpnPkg ];

    environment.systemPackages = [ nordvpnPkg ];

    systemd.services.nordvpnd = {
      after = [ "network-online.target" ];
      description = "NordVPN daemon.";
      path = (
        with pkgs;
        [
          e2fsprogs
          iproute2
          iptables
          procps
          sysctl
          wireguard-tools
        ]
        ++ [
          cfg.package
        ]
      );
      serviceConfig = {
        AmbientCapabilities = "CAP_NET_ADMIN";
        CapabilityBoundingSet = "CAP_NET_ADMIN";
        ExecStart = ''${lib.getExe' nordvpnPkg "nordvpnd"}'';
        Group = "nordvpn";
        KillMode = "process";
        NonBlocking = true;
        Requires = "nordvpnd.socket";
        Restart = "on-failure";
        RestartSec = 5;
        RuntimeDirectory = "nordvpn";
        RuntimeDirectoryMode = "0750";
        StateDirectory = "nordvpn";
        User = "nordvpn";
      };
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
    };

    systemd.user.services.norduserd = {
      description = "NordUserD Service";
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${nordvpnPkg}/bin/norduserd";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

  };

  meta = {
    maintainers = with lib.maintainers; [ sanferdsouza ];
  };
}
