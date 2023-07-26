{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.networking.nftables;

  tableSubmodule = { name, ... }: {
    options = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Enable this table.";
      };

      name = mkOption {
        type = types.str;
        description = lib.mdDoc "Table name.";
      };

      content = mkOption {
        type = types.lines;
        description = lib.mdDoc "The table content.";
      };

      family = mkOption {
        description = lib.mdDoc "Table family.";
        type = types.enum [ "ip" "ip6" "inet" "arp" "bridge" "netdev" ];
      };
    };

    config = {
      name = mkDefault name;
    };
  };
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

    networking.nftables.checkRulesetRedirects = mkOption {
      type = types.addCheck (types.attrsOf types.path) (attrs: all types.path.check (attrNames attrs));
      default = {
        "/etc/hosts" = config.environment.etc.hosts.source;
        "/etc/protocols" = config.environment.etc.protocols.source;
        "/etc/services" = config.environment.etc.services.source;
      };
      defaultText = literalExpression ''
        {
          "/etc/hosts" = config.environment.etc.hosts.source;
          "/etc/protocols" = config.environment.etc.protocols.source;
          "/etc/services" = config.environment.etc.services.source;
        }
      '';
      description = mdDoc ''
        Set of paths that should be intercepted and rewritten while checking the ruleset
        using `pkgs.buildPackages.libredirect`.
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

    networking.nftables.flushRuleset = mkEnableOption (lib.mdDoc "Flush the entire ruleset on each reload.");

    networking.nftables.extraDeletions = mkOption {
      type = types.lines;
      default = "";
      example = ''
        # this makes deleting a non-existing table a no-op instead of an error
        table inet some-table;

        delete table inet some-table;
      '';
      description =
        lib.mdDoc ''
          Extra deletion commands to be run on every firewall start, reload
          and after stopping the firewall.
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
          Note that if the tables should be cleaned first, either:
          - networking.nftables.flushRuleset = true; needs to be set (flushes all tables)
          - networking.nftables.extraDeletions needs to be set
          - or networking.nftables.tables can be used, which will clean up the table automatically
        '';
    };
    networking.nftables.rulesetFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description =
        lib.mdDoc ''
          The ruleset file to be used with nftables.  Should be in a format that
          can be loaded using "nft -f".  The ruleset is updated atomically.
        '';
    };
    networking.nftables.tables = mkOption {
      type = types.attrsOf (types.submodule tableSubmodule);

      default = {};

      description = lib.mdDoc ''
        Tables to be added to ruleset.
        Tables will be added together with delete statements to clean up the table before every update.
      '';

      example = {
        filter = {
          family = "inet";
          content = ''
            # Check out https://wiki.nftables.org/ for better documentation.
            # Table for both IPv4 and IPv6.
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
          '';
        };
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    boot.blacklistedKernelModules = [ "ip_tables" ];
    environment.systemPackages = [ pkgs.nftables ];
    networking.networkmanager.firewallBackend = mkDefault "nftables";
    # versionOlder for backportability, remove afterwards
    networking.nftables.flushRuleset = mkDefault (versionOlder config.system.stateVersion "23.11" || (cfg.rulesetFile != null || cfg.ruleset != ""));
    systemd.services.nftables = {
      description = "nftables firewall";
      before = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadIfChanged = true;
      serviceConfig = let
        enabledTables = filterAttrs (_: table: table.enable) cfg.tables;
        deletionsScript = pkgs.writeScript "nftables-deletions" ''
          #! ${pkgs.nftables}/bin/nft -f
          ${if cfg.flushRuleset then "flush ruleset"
            else concatStringsSep "\n" (mapAttrsToList (_: table: ''
              table ${table.family} ${table.name}
              delete table ${table.family} ${table.name}
            '') enabledTables)}
          ${cfg.extraDeletions}
        '';
        deletionsScriptVar = "/var/lib/nftables/deletions.nft";
        ensureDeletions = pkgs.writeShellScript "nftables-ensure-deletions" ''
          touch ${deletionsScriptVar}
          chmod +x ${deletionsScriptVar}
        '';
        saveDeletionsScript = pkgs.writeShellScript "nftables-save-deletions" ''
          cp ${deletionsScript} ${deletionsScriptVar}
        '';
        cleanupDeletionsScript = pkgs.writeShellScript "nftables-cleanup-deletions" ''
          rm ${deletionsScriptVar}
        '';
        rulesScript = pkgs.writeTextFile {
          name =  "nftables-rules";
          executable = true;
          text = ''
            #! ${pkgs.nftables}/bin/nft -f
            # previous deletions, if any
            include "${deletionsScriptVar}"
            # current deletions
            include "${deletionsScript}"
            ${concatStringsSep "\n" (mapAttrsToList (_: table: ''
              table ${table.family} ${table.name} {
                ${table.content}
              }
            '') enabledTables)}
            ${cfg.ruleset}
            ${lib.optionalString (cfg.rulesetFile != null) ''
              include "${cfg.rulesetFile}"
            ''}
          '';
          checkPhase = lib.optionalString cfg.checkRuleset ''
            cp $out ruleset.conf
            sed 's|include "${deletionsScriptVar}"||' -i ruleset.conf
            ${cfg.preCheckRuleset}
            export NIX_REDIRECTS=${escapeShellArg (concatStringsSep ":" (mapAttrsToList (n: v: "${n}=${v}") cfg.checkRulesetRedirects))}
            LD_PRELOAD="${pkgs.buildPackages.libredirect}/lib/libredirect.so ${pkgs.buildPackages.lklWithFirewall.lib}/lib/liblkl-hijack.so" \
              ${pkgs.buildPackages.nftables}/bin/nft --check --file ruleset.conf
          '';
        };
      in {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = [ ensureDeletions rulesScript ];
        ExecStartPost = saveDeletionsScript;
        ExecReload = [ ensureDeletions rulesScript saveDeletionsScript ];
        ExecStop = [ deletionsScriptVar cleanupDeletionsScript ];
        StateDirectory = "nftables";
      };
    };
  };
}
