{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.networking.bpfilter;

  chainSubmodule =
    {
      name,
      ...
    }:
    {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable this chain.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          description = "The chain's name.";
        };

        content = lib.mkOption {
          type = lib.types.lines;
          description = "The chain's content.";
        };

        hook = lib.mkOption {
          type = lib.types.enum [
            "BF_HOOK_XDP"
            "BF_HOOK_TC_INGRESS"
            "BF_HOOK_NF_PRE_ROUTING"
            "BF_HOOK_NF_LOCAL_IN"
            "BF_HOOK_CGROUP_SKB_INGRESS"
            "BF_HOOK_CGROUP_SKB_EGRESS"
            "BF_HOOK_NF_FORWARD"
            "BF_HOOK_NF_LOCAL_OUT"
            "BF_HOOK_NF_POST_ROUTING"
            "BF_HOOK_TC_EGRESS"
            "BF_HOOK_CGROUP_SOCK_ADDR_CONNECT4"
            "BF_HOOK_CGROUP_SOCK_ADDR_CONNECT6"
            "BF_HOOK_CGROUP_SOCK_ADDR_SENDMSG4"
            "BF_HOOK_CGROUP_SOCK_ADDR_SENDMSG6"
          ];
          description = "The targeted eBPF kernel hook environment.";
        };

        policy = lib.mkOption {
          type = lib.types.enum [
            "ACCEPT"
            "DROP"
            "NEXT"
          ];
          description = "The action taken in case no rule matched.";
        };

        ifindex = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Required for XDP / TC hooks.";
        };

        cgpath = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Required for CGROUP hooks.";
        };

        priorities = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Required for NF (Netfilter) hooks. Must be two different integers separated by a dash.";
        };
      };
      config = {
        name = lib.mkDefault name;
      };
    };

  generateOptionsString =
    chainCfg:
    let
      opts = lib.flatten [
        (lib.optional (chainCfg.ifindex != null) "ifindex=${toString chainCfg.ifindex}")
        (lib.optional (chainCfg.cgpath != null) "cgpath=${chainCfg.cgpath}")
        (lib.optional (chainCfg.priorities != null) "priorities=${chainCfg.priorities}")
      ];
    in
    if opts == [ ] then "" else "{${lib.concatStringsSep "," opts}}";

  generateChainConfig = chainName: chainCfg: ''
    chain ${chainName} ${chainCfg.hook}${generateOptionsString chainCfg} ${chainCfg.policy}
    ${lib.trim chainCfg.content}
  '';

  compiledChainsText = lib.concatStringsSep "\n\n" (
    lib.mapAttrsToList (name: value: generateChainConfig name value) (
      lib.filterAttrs (n: v: v.enable) cfg.chains
    )
  );
in
{
  options.networking.bpfilter = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable bpfilter and use bpfilter based firewall.
        bpfilter is a eBPF program designed to replace both nftables
        and legacy iptables firewall frameworks.
      '';
    };

    ruleset = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = "";
      example = ''
        chain my_tc_chain BF_HOOK_TC_INGRESS{ifindex=2} ACCEPT
          counters policy 87 packets 9085 bytes; error 0 packets 0 bytes
          rule
            ip4.saddr eq 0xc0 0xa8 0x01 0x01 0xff 0xff 0xff 0xff
            counters 2 packets 196 bytes
            ACCEPT
      '';
      description = ''
        The ruleset to be used with bpfilter. Should be in a format
        that could be loaded using `bfcli ruleset set --from-file myruleset.txt`
        - networking.bpfilter.flushRullsets = true; should be set;
        - network.bpfilter.chains also could be used;
      '';
    };

    rulesetCheck = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to run `bfcli ruleset set` with `--dry-run` flag.
      '';
    };

    rulesetFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        The rulest file to be used with bpfilter. Should be in a
        format that could be loaded with
        `bfcli ruleset set --from-file`.
      '';
    };

    rulesetFlush = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to flush entire ruleset on each reload.
      '';
    };

    chains = lib.mkOption {
      type = lib.types.attrListOf (lib.types.submodule chainSubmodule);

      default = { };

      description = ''
        Chains to be added to the bpfilter runtime layout.
        Each defined attribute set compiles to an isolated eBPF program block.
      '';

      example = {
        filter_wan = {
          hook = "BF_HOOK_XDP";
          ifindex = 2;
          policy = "DROP";
          content = ''
            rule ip4.proto eq tcp tcp.dport eq 22 ACCEPT
            rule ip4.proto eq icmp ACCEPT
          '';
        };
      };
    };

    chainsCheck = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to run `bfcli chain set` with `--dry-run` flag.
      '';
    };

    chainsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        The chain file to be used with bpfilter. Should be in a
        format that could be loaded with
        `bfcli chain set --from-file`.
      '';
    };

    chainsFlush = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to flush chains on each reload.
      '';
    };

    translations = {
      useNftables = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          The option to use libbpfilter to translate nftables chains rulesets
          and tables to bpfilter.

          At current upstream state this feature considered "broken",
          use with caution.
        '';
      };

      useIptables = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          The option to use libbpfilter to iptables chains, rulesets and
          tabeles to bpfilter.

          At current upstream state this feature considered "broken",
          use with caution.
        '';
      };

      nftablesFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The nftables ruleset, tables or chains file for libbpfilter
          to translate. Will be checked by nft binary.
        '';
      };

      iptablesFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The iptables ruleset, tables or chains file fot libbpfilter
          to translate. Will be checked by iptables binary.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.networking.firewall.enable;
        message = "To use `networking.bpfilter`, you must explicitly set `networking.firewall.enable = false;` to prevent eBPF hook conflicts.";
      }
      {
        assertion = !config.networking.nftables.enable;
        message = "To use `networking.bpfilter`, you must explicitly set `networking.nftables.enable = false;` to prevent eBPF hook conflicts.";
      }
      {
        assertion = !(cfg.ruleset != null && cfg.chains != { });
        message = "You cannot configure both `networking.bpfilter.ruleset` and `networking.bpfilter.chains` at the same time!";
      }
      {
        assertion =
          !(
            (cfg.translations.nftablesFile != null || cfg.translations.iptablesFile != null)
            && (cfg.ruleset != null || cfg.chains != { })
          );
        message = "You cannot mix compatibility files (nftablesFile/iptablesFile) with native bpfilter configurations (ruleset/chains)!";
      }
      {
        assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.1";
        message = "bpfilter requires advanced eBPF structures and ring buffers only fully stable on kernel versions >= 6.1.";
      }
      {
        assertion = config.boot.kernel.sysctl."net.core.bpf_jit_enable" or 1 == 1;
        message = "bpfilter requires the eBPF JIT compiler to run. Ensure boot.kernel.sysctl.\"net.core.bpf_jit_enable\" is not set to 0.";
      }
      {
        assertion = !lib.elem "bpfilter" config.boot.blacklistedKernelModules;
        message = "bpfilter";
      }
    ];

    warnings =
      [ ]
      ++ lib.optional (cfg.translations.useNftables != null) ''
        networking.bpfilter.translations.useNftables is enabled, but upstream translation support is currently broken!
      ''
      ++ lib.optional (cfg.translations.useIptables != null) ''
        networking.bpfilter.translations.useIptables is enabled, but upstream translation support is currently broken!
      '';

    boot.blacklistedKernelModules = [
      "ip_tables"
      "ip6_tables"
      "arp_tables"
      "ebtables"
    ];
    environment.systemPackages = [ pkgs.bpfilter ];

    systemd.services = {
      "bpfilter" =
        let
          finalArgs = lib.concatLists [
            (lib.optionals (cfg.translations.useIptables == null) [ "--no-iptables" ])
            (lib.optionals (cfg.translations.useNftables == null) [ "--no-nftables" ])
            cfg.extraArgs
          ];

          finalChainsFile =
            if cfg.chainsFile != null then
              cfg.chainsFile
            else
              pkgs.writeText "bpfilter-chains.conf" (
                lib.concatStringsSep "\n" (
                  lib.mapAttrsToList (
                    chainName: chainConf:
                    let
                      hookArgs = lib.concatStringsSep " " (
                        lib.concatLists [
                          (lib.optionals (chainConf.ifindex != null) [ "ifindex=${toString chainConf.ifindex}" ])
                          (lib.optionals (chainConf.cgpath != null) [ "cgpath=${chainConf.cgpath}" ])
                          (lib.optionals (chainConf.priorities != null) [ "priorities=${chainConf.priorities}" ])
                        ]
                      );

                      hookString = if hookArgs != "" then "${chainConf.hook}{${hookArgs}}" else chainConf.hook;
                    in
                    lib.optionalString chainConf.enable ''
                      chain ${chainName} ${hookString} ${chainConf.policy}
                      ${chainConf.content}
                    ''
                  ) cfg.chains
                )
              );

          finalRulesetFile =
            if cfg.rulesetFile != null then
              cfg.rulesetFile
            else
              pkgs.writeText "bpfilter-ruleset.conf" (if cfg.ruleset != null then cfg.ruleset else "");
        in
        {
          description = "bpfilter eBPF Kernel Firewall Daemon";
          after = [ "network-pre.target" ];
          wants = [ "network-pre.target" ];
          wantedBy = [
            "network-pre.target"
            "multi-user.target"
          ];
          reloadIfChanged = true;

          unitConfig.ConditionPathIsDirectory = "/sys/fs/bpf";

          startLimitIntervalSec = 30;
          startLimitBurst = 2;

          CapabilityBoundingSet = [
            "CAP_BPF"
            "CAP_NET_ADMIN"
            "CAP_SYS_ADMIN"
          ];

          AmbientCapabilities = [
            "CAP_BPF"
            "CAP_NET_ADMIN"
            "CAP_SYS_ADMIN"
          ];

          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectKernelTunables = true;
          RestrictRealtime = true;
          MemoryDenyWriteExecute = true;

          serviceConfig = {
            ExecStart = "${lib.getExe' pkgs.bpfilter "bpfilter"} --bpffs-path=${cfg.bpffsPath} ${lib.escapeShellArgs finalArgs}";

            ExecStartPost =
              [ ]
              ++ lib.optionals (cfg.chains != { } || cfg.chainsFile != null) (
                lib.optional cfg.chainFlush "${lib.getExe' pkgs.bpfilter "bpcli"} chain flush"
                ++ lib.optional cfg.chainCheck "${lib.getExe' pkgs.bpfilter "bpcli"} chain set --dry-run --from-file ${finalChainsFile}"
                ++ [ "${lib.getExe' pkgs.bpfilter "bpcli"} chain set --from-file ${finalChainsFile}" ]
              )
              ++ lib.optionals (cfg.ruleset != null || cfg.rulesetFile != null) (
                lib.optional cfg.rulesetFlush "${lib.getExe' pkgs.bpfilter "bpcli"} ruleset flush"
                ++ lib.optional cfg.rulesetCheck "${lib.getExe' pkgs.bpfilter "bpcli"} ruleset set --dry-run --from-file ${finalRulesetFile}"
                ++ [ "${lib.getExe' pkgs.bpfilter "bpcli"} ruleset set --from-file ${finalRulesetFile}" ]
              );

            Restart = "always";
            Type = "simple";
          };
        };

      "bpfilter-nft-import" = lib.mkIf (cfg.translations.useNftables != null) {
        description = "bpfilter nftables Compatibility Translation Worker";
        requires = [ "bpfilter.service" ];
        after = [ "bpfilter.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;

          CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
          AmbientCapabilities = [ "CAP_NET_ADMIN" ];

          NoNewPrivileges = true;
          ProtectSystem = "full";
          ProtectHome = "read-only";
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectKernelTunables = true;
          RestrictRealtime = true;
          MemoryDenyWriteExecute = true;

          ExecStart = [
            "${lib.getExe' pkgs.nftables "nft"} --check -f ${cfg.translations.nftablesFile}"
            "${lib.getExe' pkgs.nftables "nft"} -f ${cfg.translations.nftablesFile}"
          ];
        };
      };

      "bpfilter-iptables-import" = lib.mkIf (cfg.translations.useIptables != null) {
        description = "bpfilter iptables Compatibility Translation Worker";
        requires = [ "bpfilter.service" ];
        after = [ "bpfilter.service" ];
        wantedBy = [ "multi-user.target" ];

        CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
        AmbientCapabilities = [ "CAP_NET_ADMIN" ];

        NoNewPrivileges = true;
        ProtectSystem = "full";
        ProtectHome = "read-only";
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelTunables = true;
        RestrictRealtime = true;
        MemoryDenyWriteExecute = true;

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = [
            "${lib.getExe' pkgs.iptables "iptables-restore"} --test ${cfg.translations.iptablesFile}"
            "${lib.getExe' pkgs.iptables "iptables-restore"} ${cfg.translations.iptablesFile}"
          ];
        };
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ s0me1newithhand7s ];
  };
}
