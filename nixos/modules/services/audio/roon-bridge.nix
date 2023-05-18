{ config, lib, pkgs, ... }:

with lib;

let
  name = "roon-bridge";
  cfg = config.services.roon-bridge;
in {
  options = {
    services.roon-bridge = {
      enable = mkEnableOption (lib.mdDoc "Roon Bridge");
      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open ports in the firewall for the bridge.
        '';
      };
      user = mkOption {
        type = types.str;
        default = "roon-bridge";
        description = lib.mdDoc ''
          User to run the Roon bridge as.
        '';
      };
      group = mkOption {
        type = types.str;
        default = "roon-bridge";
        description = lib.mdDoc ''
          Group to run the Roon Bridge as.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.roon-bridge = {
      after = [ "network.target" ];
      description = "Roon Bridge";
      wantedBy = [ "multi-user.target" ];

      environment.ROON_DATAROOT = "/var/lib/${name}";

      serviceConfig = {
        ExecStart = "${pkgs.roon-bridge}/bin/RoonBridge";
        LimitNOFILE = 8192;
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = name;
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPortRanges = [{ from = 9100; to = 9200; }];
      allowedUDPPorts = [ 9003 ];
      extraCommands = optionalString (!config.networking.nftables.enable) ''
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
      if cfg.user == "roon-bridge" then {
        isSystemUser = true;
        description = "Roon Bridge user";
        group = cfg.group;
        extraGroups = [ "audio" ];
      }
      else {};
  };
}
