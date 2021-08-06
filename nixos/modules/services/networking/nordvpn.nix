{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nordvpn;
  package = pkgs.nordvpn;
in {
  options.services.nordvpn = {
    enable = mkEnableOption "nordvpn";

    connect = {
      technology = mkOption {
        type = types.str;
        default = "OpenVPN";
        description = ''
          Technology to use in NordVPN , two possible option are 'OpenVPN' and 'NordLynx'
        '';
      };

      autoconnect = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Autoconnect to NordVPN using NixOS options
        '';
      };

      username = mkOption {
        type = types.str;
        default = "";
        description = ''
          Username to use during NordVPN login
        '';
      };

      passwordFile = mkOption {
        type = types.str;
        default = "";
        description = ''
          Password file to use during NordVPN login
        '';
      };

      connectLocation = mkOption {
        type = types.str;
        default = "";
        description = ''
          Connection location for NordVPN , it can be country code, location, etc
        '';
      };
    };
  };

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
        ${pkgs.xorg.lndir}/bin/lndir ${package}/var/lib/nordvpn /var/lib/nordvpn
      '';

      serviceConfig = {
        ExecStart = "${package}/bin/nordvpnd";
        StateDirectory = "nordvpn";
      };
    };

    systemd.services.nordvpnd-login = mkIf cfg.connect.autoconnect {
      wantedBy = [ "default.target" ];
      after = [ "nordvpnd.service" ];

      path = [
        package
      ];

      script = ''
        nordvpn disconnect
        nordvpn set technology ${cfg.connect.technology}
        nordvpn logout
        nordvpn login --username ${cfg.connect.username} --password "$(cat ${cfg.connect.passwordFile})"
        nordvpn connect "${cfg.connect.connectLocation}"
      '';

      serviceConfig = {
        Type = "oneshot";
      };
    };

    environment.systemPackages = [ package ];
  };
}
