{ config, lib, pkgs, ... }:

let

  cfg = config.services.keepalived;

  keepalivedConf = pkgs.writeText "keepalived.conf" ''
    global_defs {
      ${lib.optionalString cfg.enableScriptSecurity "enable_script_security"}
      ${snmpGlobalDefs}
      ${cfg.extraGlobalDefs}
    }

    ${vrrpScriptStr}
    ${vrrpInstancesStr}
    ${cfg.extraConfig}
  '';

  snmpGlobalDefs = with cfg.snmp; lib.optionalString enable (
    lib.optionalString (socket != null) "snmp_socket ${socket}\n"
    + lib.optionalString enableKeepalived "enable_snmp_keepalived\n"
    + lib.optionalString enableChecker "enable_snmp_checker\n"
    + lib.optionalString enableRfc "enable_snmp_rfc\n"
    + lib.optionalString enableRfcV2 "enable_snmp_rfcv2\n"
    + lib.optionalString enableRfcV3 "enable_snmp_rfcv3\n"
    + lib.optionalString enableTraps "enable_traps"
  );

  vrrpScriptStr = lib.concatStringsSep "\n" (map (s:
    ''
      vrrp_script ${s.name} {
        script "${s.script}"
        interval ${toString s.interval}
        fall ${toString s.fall}
        rise ${toString s.rise}
        timeout ${toString s.timeout}
        weight ${toString s.weight}
        user ${s.user} ${lib.optionalString (s.group != null) s.group}

        ${s.extraConfig}
      }
    ''
  ) vrrpScripts);

  vrrpInstancesStr = lib.concatStringsSep "\n" (map (i:
    ''
      vrrp_instance ${i.name} {
        interface ${i.interface}
        state ${i.state}
        virtual_router_id ${toString i.virtualRouterId}
        priority ${toString i.priority}
        ${lib.optionalString i.noPreempt "nopreempt"}

        ${lib.optionalString i.useVmac (
          "use_vmac" + lib.optionalString (i.vmacInterface != null) " ${i.vmacInterface}"
        )}
        ${lib.optionalString i.vmacXmitBase "vmac_xmit_base"}

        ${lib.optionalString (i.unicastSrcIp != null) "unicast_src_ip ${i.unicastSrcIp}"}
        ${lib.optionalString (builtins.length i.unicastPeers > 0) ''
          unicast_peer {
            ${lib.concatStringsSep "\n" i.unicastPeers}
          }
        ''}

        virtual_ipaddress {
          ${lib.concatMapStringsSep "\n" virtualIpLine i.virtualIps}
        }

        ${lib.optionalString (builtins.length i.trackScripts > 0) ''
          track_script {
            ${lib.concatStringsSep "\n" i.trackScripts}
          }
        ''}

        ${lib.optionalString (builtins.length i.trackInterfaces > 0) ''
          track_interface {
            ${lib.concatStringsSep "\n" i.trackInterfaces}
          }
        ''}

        ${i.extraConfig}
      }
    ''
  ) vrrpInstances);

  virtualIpLine = ip: ip.addr
    + lib.optionalString (notNullOrEmpty ip.brd) " brd ${ip.brd}"
    + lib.optionalString (notNullOrEmpty ip.dev) " dev ${ip.dev}"
    + lib.optionalString (notNullOrEmpty ip.scope) " scope ${ip.scope}"
    + lib.optionalString (notNullOrEmpty ip.label) " label ${ip.label}";

  notNullOrEmpty = s: !(s == null || s == "");

  vrrpScripts = lib.mapAttrsToList (name: config:
    {
      inherit name;
    } // config
  ) cfg.vrrpScripts;

  vrrpInstances = lib.mapAttrsToList (iName: iConfig:
    {
      name = iName;
    } // iConfig
  ) cfg.vrrpInstances;

  vrrpInstanceAssertions = i: [
    { assertion = i.interface != "";
      message = "services.keepalived.vrrpInstances.${i.name}.interface option cannot be empty.";
    }
    { assertion = i.virtualRouterId >= 0 && i.virtualRouterId <= 255;
      message = "services.keepalived.vrrpInstances.${i.name}.virtualRouterId must be an integer between 0..255.";
    }
    { assertion = i.priority >= 0 && i.priority <= 255;
      message = "services.keepalived.vrrpInstances.${i.name}.priority must be an integer between 0..255.";
    }
    { assertion = i.vmacInterface == null || i.useVmac;
      message = "services.keepalived.vrrpInstances.${i.name}.vmacInterface has no effect when services.keepalived.vrrpInstances.${i.name}.useVmac is not set.";
    }
    { assertion = !i.vmacXmitBase || i.useVmac;
      message = "services.keepalived.vrrpInstances.${i.name}.vmacXmitBase has no effect when services.keepalived.vrrpInstances.${i.name}.useVmac is not set.";
    }
  ] ++ lib.flatten (map (virtualIpAssertions i.name) i.virtualIps)
    ++ lib.flatten (map (vrrpScriptAssertion i.name) i.trackScripts);

  virtualIpAssertions = vrrpName: ip: [
    { assertion = ip.addr != "";
      message = "The 'addr' option for an services.keepalived.vrrpInstances.${vrrpName}.virtualIps entry cannot be empty.";
    }
  ];

  vrrpScriptAssertion = vrrpName: scriptName: {
    assertion = builtins.hasAttr scriptName cfg.vrrpScripts;
    message = "services.keepalived.vrrpInstances.${vrrpName} trackscript ${scriptName} is not defined in services.keepalived.vrrpScripts.";
  };

  pidFile = "/run/keepalived.pid";

in
{
  meta.maintainers = [ lib.maintainers.raitobezarius ];

  options = {
    services.keepalived = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable Keepalived.
        '';
      };

      package = lib.mkPackageOption pkgs "keepalived" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to automatically allow VRRP and AH packets in the firewall.
        '';
      };

      enableScriptSecurity = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Don't run scripts configured to be run as root if any part of the path is writable by a non-root user.
        '';
      };

      snmp = {

        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to enable the builtin AgentX subagent.
          '';
        };

        socket = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Socket to use for connecting to SNMP master agent. If this value is
            set to null, keepalived's default will be used, which is
            unix:/var/agentx/master, unless using a network namespace, when the
            default is udp:localhost:705.
          '';
        };

        enableKeepalived = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable SNMP handling of vrrp element of KEEPALIVED MIB.
          '';
        };

        enableChecker = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable SNMP handling of checker element of KEEPALIVED MIB.
          '';
        };

        enableRfc = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable SNMP handling of RFC2787 and RFC6527 VRRP MIBs.
          '';
        };

        enableRfcV2 = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable SNMP handling of RFC2787 VRRP MIB.
          '';
        };

        enableRfcV3 = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable SNMP handling of RFC6527 VRRP MIB.
          '';
        };

        enableTraps = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable SNMP traps.
          '';
        };

      };

      vrrpScripts = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule (import ./vrrp-script-options.nix {
          inherit lib;
        }));
        default = {};
        description = "Declarative vrrp script config";
      };

      vrrpInstances = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule (import ./vrrp-instance-options.nix {
          inherit lib;
        }));
        default = {};
        description = "Declarative vhost config";
      };

      extraGlobalDefs = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra lines to be added verbatim to the 'global_defs' block of the
          configuration file
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra lines to be added verbatim to the configuration file.
        '';
      };

      secretFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/keepalived.env";
        description = ''
          Environment variables from this file will be interpolated into the
          final config file using envsubst with this syntax: `$ENVIRONMENT`
          or `''${VARIABLE}`.
          The file should contain lines formatted as `SECRET_VAR=SECRET_VALUE`.
          This is useful to avoid putting secrets into the nix store.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {

    assertions = lib.flatten (map vrrpInstanceAssertions vrrpInstances);

    networking.firewall = lib.mkIf cfg.openFirewall {
      extraCommands = ''
        # Allow VRRP and AH packets
        ip46tables -A nixos-fw -p vrrp -m comment --comment "services.keepalived.openFirewall" -j ACCEPT
        ip46tables -A nixos-fw -p ah -m comment --comment "services.keepalived.openFirewall" -j ACCEPT
      '';

      extraStopCommands = ''
        ip46tables -D nixos-fw -p vrrp -m comment --comment "services.keepalived.openFirewall" -j ACCEPT
        ip46tables -D nixos-fw -p ah -m comment --comment "services.keepalived.openFirewall" -j ACCEPT
      '';
    };

    systemd.timers.keepalived-boot-delay = {
      description = "Keepalive Daemon delay to avoid instant transition to MASTER state";
      after = [ "network.target" "network-online.target" ];
      requires = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      timerConfig = {
        OnActiveSec = "5s";
        Unit = "keepalived.service";
      };
    };

    systemd.services.keepalived = let
      finalConfigFile = if cfg.secretFile == null then keepalivedConf else "/run/keepalived/keepalived.conf";
    in {
      description = "Keepalive Daemon (LVS and VRRP)";
      after = [ "network.target" "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "forking";
        PIDFile = pidFile;
        KillMode = "process";
        RuntimeDirectory = "keepalived";
        EnvironmentFile = lib.optional (cfg.secretFile != null) cfg.secretFile;
        ExecStartPre = lib.optional (cfg.secretFile != null)
        (pkgs.writeShellScript "keepalived-pre-start" ''
          umask 077
          ${pkgs.envsubst}/bin/envsubst -i "${keepalivedConf}" > ${finalConfigFile}
        '');
        ExecStart = "${lib.getExe cfg.package}"
          + " -f ${finalConfigFile}"
          + " -p ${pidFile}"
          + lib.optionalString cfg.snmp.enable " --snmp";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "always";
        RestartSec = "1s";
      };
    };
  };
}
