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

    systemd.packages = [ cfg.package ];

    systemd.sockets.nordvpnd.wantedBy = [ "sockets.target" ];

    systemd.services.nordvpnd = {
      wantedBy = ["default.target"];
      path = with pkgs; [
        iptables
        iproute2
        sysctl
      ];

      # NOTE: the preStart process is needed to provide RSA key and server list for the nordvpn daemon
      # NOTE: and the openvpn copying is due to the openvpn that come with the package is using /sbin/ip which doesn't exist in nixos
      preStart = ''
        cp -r ${cfg.package}/var/lib/nordvpn/* /var/lib/nordvpn/
        cp ${pkgs.openvpn}/bin/openvpn /var/lib/nordvpn/openvpn
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/nordvpnd";
        StateDirectory = "nordvpn";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
