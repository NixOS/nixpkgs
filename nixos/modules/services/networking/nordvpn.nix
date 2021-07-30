{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nordvpn;
  package = pkgs.nordvpn;
in {
  options.services.nordvpn.enable = mkEnableOption "nordvpn";

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tun" ];
    networking.iproute2.enable = true;

    users.groups.nordvpn = {};

    systemd.packages = [ package ];

    systemd.sockets.nordvpnd.wantedBy = [ "sockets.target" ];

    systemd.services.nordvpnd = {
      wantedBy = ["default.target"];
      path = with pkgs; [
        iptables
        iproute2
        sysctl
      ];

      # NOTE: the preStart process is needed to provide RSA key and server list for the nordvpn daemon
      preStart = ''
        ${pkgs.xorg.lndir}/bin/lndir ${cfg.package}/var/lib/nordvpn /var/lib/nordvpn
      '';

      serviceConfig = {
        ExecStart = "${package}/bin/nordvpnd";
        StateDirectory = "nordvpn";
      };
    };

    environment.systemPackages = [ package ];
  };
}
