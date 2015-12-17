{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.miniupnpd;
  configFile = pkgs.writeText "miniupnpd.conf" ''
    ext_ifname=${cfg.externalInterface}
    enable_natpmp=${if cfg.natpmp then "yes" else "no"}
    enable_upnp=${if cfg.upnp then "yes" else "no"}

    ${concatMapStrings (range: ''
      listening_ip=${range}
    '') cfg.internalIPs}

    ${cfg.appendConfig}
  '';
in
{
  options = {
    services.miniupnpd = {
      enable = mkEnableOption "MiniUPnP daemon";

      externalInterface = mkOption {
        type = types.str;
        description = ''
          Name of the external interface.
        '';
      };

      internalIPs = mkOption {
        type = types.listOf types.str;
        example = [ "192.168.1.1/24" "enp1s0" ];
        description = ''
          The IP address ranges to listen on.
        '';
      };

      natpmp = mkEnableOption "NAT-PMP support";

      upnp = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Whether to enable UPNP support.
        '';
      };

      appendConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Configuration lines appended to the MiniUPnP config.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # from miniupnpd/netfilter/iptables_init.sh
    networking.firewall.extraCommands = ''
      iptables -t nat -N MINIUPNPD
      iptables -t nat -A PREROUTING -i ${cfg.externalInterface} -j MINIUPNPD
      iptables -t mangle -N MINIUPNPD
      iptables -t mangle -A PREROUTING -i ${cfg.externalInterface} -j MINIUPNPD
      iptables -t filter -N MINIUPNPD
      iptables -t filter -A FORWARD -i ${cfg.externalInterface} ! -o ${cfg.externalInterface} -j MINIUPNPD
      iptables -t nat -N MINIUPNPD-PCP-PEER
      iptables -t nat -A POSTROUTING -o ${cfg.externalInterface} -j MINIUPNPD-PCP-PEER
    '';

    # from miniupnpd/netfilter/iptables_removeall.sh
    networking.firewall.extraStopCommands = ''
      iptables -t nat -F MINIUPNPD
      iptables -t nat -D PREROUTING -i ${cfg.externalInterface} -j MINIUPNPD
      iptables -t nat -X MINIUPNPD
      iptables -t mangle -F MINIUPNPD
      iptables -t mangle -D PREROUTING -i ${cfg.externalInterface} -j MINIUPNPD
      iptables -t mangle -X MINIUPNPD
      iptables -t filter -F MINIUPNPD
      iptables -t filter -D FORWARD -i ${cfg.externalInterface} ! -o ${cfg.externalInterface} -j MINIUPNPD
      iptables -t filter -X MINIUPNPD
      iptables -t nat -F MINIUPNPD-PCP-PEER
      iptables -t nat -D POSTROUTING -o ${cfg.externalInterface} -j MINIUPNPD-PCP-PEER
      iptables -t nat -X MINIUPNPD-PCP-PEER
    '';

    systemd.services.miniupnpd = {
      description = "MiniUPnP daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.miniupnpd}/bin/miniupnpd -f ${configFile}";
        PIDFile = "/var/run/miniupnpd.pid";
        Type = "forking";
      };
    };
  };
}
