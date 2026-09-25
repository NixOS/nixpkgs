{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.miniupnpd;
  configFile = pkgs.writeText "miniupnpd.conf" ''
    ext_ifname=${cfg.externalInterface}
    enable_natpmp=${boolToYesNo cfg.natpmp}
    enable_upnp=${boolToYesNo cfg.upnp}

    ${concatMapStrings (range: ''
      listening_ip=${range}
    '') cfg.internalIPs}

    upnp_table_name=miniupnpd
    upnp_nat_table_name=miniupnpd

    ${cfg.appendConfig}
  '';
  miniupnpd = pkgs.miniupnpd-nftables;
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
        example = [
          "192.168.1.1/24"
          "enp1s0"
        ];
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
    assertions = [
      {
        assertion = config.networking.nftables.enable;
        message = ''
          The MiniUPnP daemon requires an nftables-based firewall.
          networking.nftables.enable must be set to true.
        '';
      }
    ];

    networking.nftables.tables.miniupnpd = {
      family = "inet";
      # miniupnpd requires the regular `miniupnpd` chain below and updates it
      # with forwarding rules, but the NixOS firewall handles forwarding itself
      # by accepting DNATed connections. Hooking another base chain with a drop
      # policy into the forward path would interfere with that firewall. Custom
      # firewalls must either accept DNATed connections or, via appendConfig,
      # put miniupnpd's forward chain in their table and jump to it from their
      # own forward chain.
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
