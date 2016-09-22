{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.networking.nftables;
in
{
  ###### interface

  options = {
    networking.nftables.enable = mkOption {
      type = types.bool;
      default = false;
      description =
        ''
          Whether to enable nftables.  nftables is a Linux-based packet
          filtering framework intended to replace frameworks like iptables.

          This conflicts with the standard networking firewall, so make sure to
          disable it before using nftables.
        '';
    };
    networking.nftables.ruleset = mkOption {
      type = types.lines;
      default =
        ''
          table inet filter {
            # Block all IPv4/IPv6 input traffic except SSH.
            chain input {
              type filter hook input priority 0;
              ct state invalid reject
              ct state {established, related} accept
              iifname lo accept
              tcp dport 22 accept
              reject
            }

            # Allow anything in.
            chain output {
              type filter hook output priority 0;
              ct state invalid reject
              ct state {established, related} accept
              oifname lo accept
              accept
            }

            chain forward {
              type filter hook forward priority 0;
              accept
            }
          }
        '';
      example =
        ''
          # Check out http://wiki.nftables.org/ for better documentation.

          define LAN = 192.168.0.1/24

          # Handle IPv4 traffic.
          table ip filter {
            chain input {
              type filter hook input priority 0;
              # Handle existing connections.
              ct state invalid reject
              ct state {established, related} accept
              # Allow loopback for applications.
              iifname lo accept
              # Allow people to ping us on LAN.
              ip protocol icmp ip daddr $LAN accept
              # Allow SSH over LAN.
              tcp dport 22 ip daddr $LAN accept
              # Reject all other output traffic.
              reject
            }

            chain output {
              type filter hook output priority 0;
              # Handle existing connections.
              ct state invalid reject
              ct state {established, related} accept
              # Allow loopback for applications.
              oifname lo accept
              # Allow the Tor user to run its daemon,
              # but only on WAN in case of compromise.
              skuid tor ip daddr != $LAN accept
              # Allowing pinging others on LAN.
              ip protocol icmp ip daddr $LAN accept
              # Reject all other output traffic.
              reject
            }

            chain forward {
              type filter hook forward priority 0;
              reject
            }
          }

          # Block all IPv6 traffic.
          table ip6 filter {
            chain input {
              type filter hook input priority 0;
              reject
            }

            chain output {
              type filter hook output priority 0;
              reject
            }

            chain forward {
              type filter hook forward priority 0;
              reject
            }
          }
        '';
      description =
        ''
          The ruleset to be used with nftables.  Should be in a format that
          can be loaded using "/bin/nft -f".  The ruleset is updated atomically.
        '';
    };
    networking.nftables.rulesetFile = mkOption {
      type = types.path;
      default = pkgs.writeTextFile {
        name = "nftables-rules";
        text = cfg.ruleset;
      };
      description =
        ''
          The ruleset file to be used with nftables.  Should be in a format that
          can be loaded using "nft -f".  The ruleset is updated atomically.
        '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    assertions = [{
      assertion = config.networking.firewall.enable == false;
      message = "You can not use nftables with services.networking.firewall.";
    }];
    boot.blacklistedKernelModules = [ "ip_tables" ];
    environment.systemPackages = [ pkgs.nftables ];
    systemd.services.nftables = {
      description = "nftables firewall";
      before = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadIfChanged = true;
      serviceConfig = let
        rulesScript = pkgs.writeScript "nftables-rules" ''
          #! ${pkgs.nftables}/bin/nft -f
          flush ruleset
          include "${cfg.rulesetFile}"
        '';
        checkScript = pkgs.writeScript "nftables-check" ''
          #! ${pkgs.stdenv.shell} -e
          if $(${pkgs.kmod}/bin/lsmod | grep -q ip_tables); then
            echo "Unload ip_tables before using nftables!" 1>&2
            exit 1
          else
            ${rulesScript}
          fi
        '';
      in {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = checkScript;
        ExecReload = checkScript;
        ExecStop = "${pkgs.nftables}/bin/nft flush ruleset";
      };
    };
  };
}
