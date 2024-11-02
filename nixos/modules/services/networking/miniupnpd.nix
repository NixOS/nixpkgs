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

    ${lib.optionalString (firewall == "nftables") ''
      upnp_table_name=miniupnpd
      upnp_nat_table_name=miniupnpd
    ''}

    ${cfg.appendConfig}
  '';
  firewall = if config.networking.nftables.enable then "nftables" else "iptables";
  miniupnpd = pkgs.miniupnpd.override { inherit firewall; };
  firewallScripts = lib.optionals (firewall == "iptables")
    ([ "iptables"] ++ lib.optional (config.networking.enableIPv6) "ip6tables");
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
    networking.firewall.extraCommands = lib.mkIf (firewallScripts != []) (builtins.concatStringsSep "\n" (map (fw: ''
      EXTIF=${cfg.externalInterface} ${pkgs.bash}/bin/bash -x ${miniupnpd}/etc/miniupnpd/${fw}_init.sh
    '') firewallScripts));

    networking.firewall.extraStopCommands = lib.mkIf (firewallScripts != []) (builtins.concatStringsSep "\n" (map (fw: ''
      EXTIF=${cfg.externalInterface} ${pkgs.bash}/bin/bash -x ${miniupnpd}/etc/miniupnpd/${fw}_removeall.sh
    '') firewallScripts));

    networking.nftables = lib.mkIf (firewall == "nftables") {
      # see nft_init in ${miniupnpd-nftables}/etc/miniupnpd
      tables.miniupnpd = {
        family = "inet";
        # The following is omitted because it's expected that the firewall is to be responsible for it.
        #
        # chain forward {
        #   type filter hook forward priority filter; policy drop;
        #   jump miniupnpd
        # }
        #
        # Otherwise, it quickly gets ugly with (potentially) two forward chains with "policy drop".
        # This means the chain "miniupnpd" never actually gets triggered and is simply there to satisfy
        # miniupnpd. If you're doing it yourself (without networking.firewall), the easiest way to get
        # it to work is adding a rule "ct status dnat accept" - this is what networking.firewall does.
        # If you don't want to simply accept forwarding for all "ct status dnat" packets, override
        # upnp_table_name with whatever your table is, create a chain "miniupnpd" in your table and
        # jump into it from your forward chain.
        content = ''
          chain miniupnpd {}
          chain prerouting_miniupnpd {
            type nat hook prerouting priority dstnat; policy accept;
          }
          chain postrouting_miniupnpd {
            type nat hook postrouting priority srcnat; policy accept;
          }
        '';
      };
    };

    systemd.services.miniupnpd = {
      description = "MiniUPnP daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${miniupnpd}/bin/miniupnpd -f ${configFile}";
        PIDFile = "/run/miniupnpd.pid";
        Type = "forking";
      };
    };
  };
}
