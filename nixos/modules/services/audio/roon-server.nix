{ config, lib, pkgs, ... }:

with lib;

let
  name = "roon-server";
  cfg = config.services.roon-server;
in {
  options = {
    services.roon-server = {
      enable = mkEnableOption "Roon Server";
      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the server.
        '';
      };
      user = mkOption {
        type = types.str;
        default = "roon-server";
        description = ''
          User to run the Roon Server as.
        '';
      };
      group = mkOption {
        type = types.str;
        default = "roon-server";
        description = ''
          Group to run the Roon Server as.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.roon-server = {
      after = [ "network.target" ];
      description = "Roon Server";
      wantedBy = [ "multi-user.target" ];

      environment.ROON_DATAROOT = "/var/lib/${name}";

      serviceConfig = {
        ExecStart = "${pkgs.roon-server}/bin/RoonServer";
        LimitNOFILE = 8192;
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = name;
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPortRanges = [
        { from = 9100; to = 9200; }
        { from = 9330; to = 9332; }
      ];
      allowedUDPPorts = [ 9003 ];
      extraCommands = ''
        iptables -A INPUT -s 224.0.0.0/4 -j ACCEPT
        iptables -A INPUT -d 224.0.0.0/4 -j ACCEPT
        iptables -A INPUT -s 240.0.0.0/5 -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type broadcast -j ACCEPT
      '';
    };


    users.groups.${cfg.group} = {};
    users.users.${cfg.user} =
      if cfg.user == "roon-server" then {
        isSystemUser = true;
        description = "Roon Server user";
        group = cfg.group;
        extraGroups = [ "audio" ];
      }
      else {};
  };
}
