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

          Note that if you have Docker enabled you will not be able to use
          nftables without intervention. Docker uses iptables internally to
          setup NAT for containers. This module disables the ip_tables kernel
          module, however Docker automatically loads the module. Please see [1]
          for more information.

          There are other programs that use iptables internally too, such as
          libvirt.

          [1]: https://github.com/NixOS/nixpkgs/issues/24318#issuecomment-289216273
        '';
    };
    networking.nftables.ruleset = mkOption {
      type = types.lines;
      example = ''
        # Check out https://wiki.nftables.org/ for better documentation.
        # Table for both IPv4 and IPv6.
        table inet filter {
          # Block all incomming connections traffic except SSH and "ping".
          chain input {
            type filter hook input priority 0;

            # accept any localhost traffic
            iifname lo accept

            # accept traffic originated from us
            ct state {established, related} accept

            # ICMP
            # routers may also want: mld-listener-query, nd-router-solicit
            ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
            ip protocol icmp icmp type { destination-unreachable, router-advertisement, time-exceeded, parameter-problem } accept

            # allow "ping"
            ip6 nexthdr icmp icmpv6 type echo-request accept
            ip protocol icmp icmp type echo-request accept

            # accept SSH connections (required for a server)
            tcp dport 22 accept

            # count and drop any other traffic
            counter drop
          }

          # Allow all outgoing connections.
          chain output {
            type filter hook output priority 0;
            accept
          }

          chain forward {
            type filter hook forward priority 0;
            accept
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
