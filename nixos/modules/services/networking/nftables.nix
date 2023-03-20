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
        lib.mdDoc ''
          Whether to enable nftables and use nftables based firewall if enabled.
          nftables is a Linux-based packet filtering framework intended to
          replace frameworks like iptables.

          Note that if you have Docker enabled you will not be able to use
          nftables without intervention. Docker uses iptables internally to
          setup NAT for containers. This module disables the ip_tables kernel
          module, however Docker automatically loads the module. Please see
          <https://github.com/NixOS/nixpkgs/issues/24318#issuecomment-289216273>
          for more information.

          There are other programs that use iptables internally too, such as
          libvirt. For information on how the two firewalls interact, see
          <https://wiki.nftables.org/wiki-nftables/index.php/Troubleshooting#Question_4._How_do_nftables_and_iptables_interact_when_used_on_the_same_system.3F>.
        '';
    };

    networking.nftables.checkRuleset = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Run `nft check` on the ruleset to spot syntax errors during build.
        Because this is executed in a sandbox, the check might fail if it requires
        access to any environmental factors or paths outside the Nix store.
        To circumvent this, the ruleset file can be edited using the preCheckRuleset
        option to work in the sandbox environment.
      '';
    };

    networking.nftables.preCheckRuleset = mkOption {
      type = types.lines;
      default = "";
      example = lib.literalExpression ''
        sed 's/skgid meadow/skgid nogroup/g' -i ruleset.conf
      '';
      description = lib.mdDoc ''
        This script gets run before the ruleset is checked. It can be used to
        create additional files needed for the ruleset check to work, or modify
        the ruleset for cases the build environment cannot cover.
      '';
    };

    networking.nftables.ruleset = mkOption {
      type = types.lines;
      default = "";
      example = ''
        # Check out https://wiki.nftables.org/ for better documentation.
        # Table for both IPv4 and IPv6.
        table inet filter {
          # Block all incoming connections traffic except SSH and "ping".
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
            ip6 nexthdr icmpv6 icmpv6 type echo-request accept
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
        lib.mdDoc ''
          The ruleset to be used with nftables.  Should be in a format that
          can be loaded using "/bin/nft -f".  The ruleset is updated atomically.
          This option conflicts with rulesetFile.
        '';
    };
    networking.nftables.rulesetFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description =
        lib.mdDoc ''
          The ruleset file to be used with nftables.  Should be in a format that
          can be loaded using "nft -f".  The ruleset is updated atomically.
          This option conflicts with ruleset and nftables based firewall.
        '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    boot.blacklistedKernelModules = [ "ip_tables" ];
    environment.systemPackages = [ pkgs.nftables ];
    networking.networkmanager.firewallBackend = mkDefault "nftables";
    systemd.services.nftables = {
      description = "nftables firewall";
      before = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadIfChanged = true;
      serviceConfig = let
        rulesScript = pkgs.writeTextFile {
          name =  "nftables-rules";
          executable = true;
          text = ''
            #! ${pkgs.nftables}/bin/nft -f
            flush ruleset
            ${if cfg.rulesetFile != null then ''
              include "${cfg.rulesetFile}"
            '' else cfg.ruleset}
          '';
          checkPhase = lib.optionalString cfg.checkRuleset ''
            cp $out ruleset.conf
            ${cfg.preCheckRuleset}
            export NIX_REDIRECTS=/etc/protocols=${pkgs.buildPackages.iana-etc}/etc/protocols:/etc/services=${pkgs.buildPackages.iana-etc}/etc/services
            LD_PRELOAD="${pkgs.buildPackages.libredirect}/lib/libredirect.so ${pkgs.buildPackages.lklWithFirewall.lib}/lib/liblkl-hijack.so" \
              ${pkgs.buildPackages.nftables}/bin/nft --check --file ruleset.conf
          '';
        };
      in {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = rulesScript;
        ExecReload = rulesScript;
        ExecStop = "${pkgs.nftables}/bin/nft flush ruleset";
      };
    };
  };
}
