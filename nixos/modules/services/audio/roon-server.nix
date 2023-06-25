{ config, lib, pkgs, ... }:

with lib;

let
  name = "roon-server";
  cfg = config.services.roon-server;
in {
  options = {
    services.roon-server = {
      enable = mkEnableOption (lib.mdDoc "Roon Server");
      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open ports in the firewall for the server.
        '';
      };
      user = mkOption {
        type = types.str;
        default = "roon-server";
        description = lib.mdDoc ''
          User to run the Roon Server as.
        '';
      };
      group = mkOption {
        type = types.str;
        default = "roon-server";
        description = lib.mdDoc ''
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
      environment.ROON_ID_DIR = "/var/lib/${name}";

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
        { from = 9330; to = 9339; }
        { from = 30000; to = 30010; }
      ];
      allowedUDPPorts = [ 9003 ];
      extraCommands = optionalString (!config.networking.nftables.enable) ''
        ## IGMP / Broadcast ##
        iptables -A INPUT -s 224.0.0.0/4 -j ACCEPT
        iptables -A INPUT -d 224.0.0.0/4 -j ACCEPT
        iptables -A INPUT -s 240.0.0.0/5 -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type broadcast -j ACCEPT
      '';
      extraInputRules = optionalString config.networking.nftables.enable ''
        ip saddr { 224.0.0.0/4, 240.0.0.0/5 } accept
        ip daddr 224.0.0.0/4 accept
        pkttype { multicast, broadcast } accept
      '';
    };


    users.groups.${cfg.group} = {};
    users.users.${cfg.user} =
      optionalAttrs (cfg.user == "roon-server") {
        isSystemUser = true;
        description = "Roon Server user";
        group = cfg.group;
        extraGroups = [ "audio" ];
      };
  };
}
