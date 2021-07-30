{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nordvpn;
in {
  options = {
    services.nordvpn = {
      enable = mkEnableOption "nordvpn";

      package = mkOption {
        description = "NordVPN Package";
        type = types.package;
        default = pkgs.nordvpn;
      };
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tun" ];

    networking.iproute2.enable = true;

    users.groups.nordvpn = {};

    systemd.sockets.nordvpnd = {
      description = "NordVPN Daemon Socket";
      partOf = [ "nordvpnd.service" ];
      listenStreams = [ "/run/nordvpn/nordvpnd.sock" ];
      wantedBy = [ "sockets.target" ];

      socketConfig = {
        NoDelay = "true";
        SocketGroup = "nordvpn";
        SocketMode = "0770";
      };
    };

    systemd.services.nordvpnd = {
      description = "NordVPN Daemon";
      requires = [ "nordvpnd.socket" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      wantedBy = ["default.target"];

      path = [
        pkgs.iptables
        pkgs.iproute2
        pkgs.sysctl
      ];

      preStart = ''
        cp -r ${cfg.package}/var/lib/nordvpn/* /var/lib/nordvpn/
        cp ${pkgs.openvpn}/bin/openvpn /var/lib/nordvpn/openvpn
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/nordvpnd";
        NonBlocking = "true";
        KillMode = "process";
        Restart = "on-failure";
        RestartSec = "5";
        Group = "nordvpn";
      };
    };

    systemd.tmpfiles.rules = mkAfter [
      "d /run/nordvpn 0770 root nordvpn"
      # Maybe there is a better way to address this?
      "d /var/lib/nordvpn/ 0770 root nordvpn"
    ];

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = [ cfg.package ];
  };
}
