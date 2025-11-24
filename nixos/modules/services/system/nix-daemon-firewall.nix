{ config, lib, ... }:
let

  cfg = config.nix.firewall;

in
{
  options.nix.firewall = {
    enable = lib.mkEnableOption "firewalling for outgoing traffic of the nix daemon";

    allowLoopback = lib.mkOption {
      description = "Whether not not to allow traffic on the loopback interface. Traffic is still subject to protocol/port rules";
      default = false;
      example = true;
    };

    allowPrivateNetworks = lib.mkOption {
      description = "Whether not not to allow traffic to local networks. Traffic is still subject to protocol/port rules. Note that this option may break DNS resolution when the DNS resolver is in a local network";
      default = true;
      example = false;
    };

    allowNonTCPUDP = lib.mkOption {
      description = "Whether to allow traffic that is neither TCP nor UDP";
      type = lib.types.bool;
      default = false;
      example = true;
    };

    allowedTCPPorts = lib.mkOption {
      description = "TCP ports to which traffic is allowed. Specifying no ports will allow all TCP traffic";
      type = lib.types.listOf (
        lib.types.oneOf [
          lib.types.singleLineStr
          lib.types.port
        ]
      );
      default = [ ];
      example = [
        "http"
        443
        "30000-31000"
      ];
    };

    allowedUDPPorts = lib.mkOption {
      description = "UDP ports to which traffic is allowed. Specifying no ports will allow all UDP traffic";
      type = lib.types.listOf (
        lib.types.oneOf [
          lib.types.singleLineStr
          lib.types.port
        ]
      );
      default = [ ];
      example = [ 53 ];
    };

    extraNftablesRules = lib.mkOption {
      description = "Extra nftables rules to prepend to the generated ones";
      type = lib.types.listOf lib.types.singleLineStr;
      default = [ ];
      example = [ "ip daddr 1.1.1.1 udp dport accept" ];
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure we can properly use nftables
    assertions = [
      {
        assertion = config.networking.nftables.enable;
        message = ''
          The nix-daemon firewall requires an nftables-based firewall.
          networking.nftables.enable must be set to true.
        '';
      }
      {
        assertion = !config.networking.nftables.flushRuleset;
        message = ''
          The nix-daemon firewall writes extra tables to nftables.
          networking.nftables.flushRuleset must be set to false.
        '';
      }
    ];

    systemd.services.nix-daemon = {
      after = [ "nftables.service" ];
      # Add the cgroup ID to a nft set on daemon start
      serviceConfig.NFTSet = "cgroup:inet:nix_daemon_firewall:nix_daemon";
    };

    # Generate nftables rules
    networking.nftables.ruleset = ''
      table inet nix_daemon_firewall {
        set nix_daemon {
          type cgroupsv2
        }
        chain output {
          type filter hook output priority 0;
          socket cgroupv2 level 2 @nix_daemon goto nix_daemon_traffic
          accept
        }
        chain nix_daemon_traffic {
          # Extra rules
          ${lib.concatStringsSep "\n" cfg.extraNftablesRules}

          # Loopback
          ${lib.optionalString (!cfg.allowLoopback) "ip daddr 127.0.0.0/8 counter drop"}
          ${lib.optionalString (!cfg.allowLoopback) "ip6 daddr ::1 counter drop"}

          # Local networks
          ${lib.optionalString (
            !cfg.allowPrivateNetworks
          ) "ip daddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 169.254.0.0/16 } counter drop"}
          ${lib.optionalString (
            !cfg.allowPrivateNetworks
          ) "ip6 daddr { fd00::/8, fe80::/10 } counter drop"}

          # TCP
          ${lib.optionalString (cfg.allowedTCPPorts != [ ]) ''
            tcp dport { ${lib.concatStringsSep ", " (map builtins.toString cfg.allowedTCPPorts)} } accept
            ip protocol tcp counter drop
            ip6 nexthdr tcp counter drop
          ''}

          # UDP
          ${lib.optionalString (cfg.allowedUDPPorts != [ ]) ''
            udp dport { ${lib.concatStringsSep ", " (map builtins.toString cfg.allowedUDPPorts)} } accept
            ip protocol udp counter drop
            ip6 nexthdr udp counter drop
          ''}

          # Non-TCP and non-UDP
          ${lib.optionalString (!cfg.allowNonTCPUDP) "ip protocol != { tcp, udp } counter drop"}
          ${lib.optionalString (!cfg.allowNonTCPUDP) "ip6 nexthdr != { tcp, udp } counter drop"}

          accept
        }
      }
    '';
  };
}
