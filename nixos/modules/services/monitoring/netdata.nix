{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.netdata;

  wrappedPlugins = pkgs.runCommand "wrapped-plugins" { preferLocalBuild = true; } ''
    mkdir -p $out/libexec/netdata/plugins.d
    ln -s /run/wrappers/bin/apps.plugin $out/libexec/netdata/plugins.d/apps.plugin
    ln -s /run/wrappers/bin/cgroup-network $out/libexec/netdata/plugins.d/cgroup-network
    ln -s /run/wrappers/bin/perf.plugin $out/libexec/netdata/plugins.d/perf.plugin
    ln -s /run/wrappers/bin/slabinfo.plugin $out/libexec/netdata/plugins.d/slabinfo.plugin
    ln -s /run/wrappers/bin/freeipmi.plugin $out/libexec/netdata/plugins.d/freeipmi.plugin
    ln -s /run/wrappers/bin/systemd-journal.plugin $out/libexec/netdata/plugins.d/systemd-journal.plugin
  '';

  plugins = [
    "${cfg.package}/libexec/netdata/plugins.d"
    "${wrappedPlugins}/libexec/netdata/plugins.d"
  ] ++ cfg.extraPluginPaths;

  configDirectory = pkgs.runCommand "netdata-config-d" { } ''
    mkdir $out
    ${concatStringsSep "\n" (mapAttrsToList (path: file: ''
        mkdir -p "$out/$(dirname ${path})"
        ln -s "${file}" "$out/${path}"
      '') cfg.configDir)}
  '';

  localConfig = {
    global = {
      "config directory" = "/etc/netdata/conf.d";
      "plugins directory" = concatStringsSep " " plugins;
    };
    web = {
      "web files owner" = "root";
      "web files group" = "root";
    };
    "plugin:cgroups" = {
      "script to get cgroup network interfaces" = "${wrappedPlugins}/libexec/netdata/plugins.d/cgroup-network";
      "use unified cgroups" = "yes";
    };
  };
  mkConfig = generators.toINI {} (recursiveUpdate localConfig cfg.config);
  configFile = pkgs.writeText "netdata.conf" (if cfg.configText != null then cfg.configText else mkConfig);

  defaultUser = "netdata";

in {
  options = {
    services.netdata = {
      enable = mkEnableOption (lib.mdDoc "netdata");

      package = mkPackageOption pkgs "netdata" { };

      user = mkOption {
        type = types.str;
        default = "netdata";
        description = lib.mdDoc "User account under which netdata runs.";
      };

      group = mkOption {
        type = types.str;
        default = "netdata";
        description = lib.mdDoc "Group under which netdata runs.";
      };

      configText = mkOption {
        type = types.nullOr types.lines;
        description = lib.mdDoc "Verbatim netdata.conf, cannot be combined with config.";
        default = null;
        example = ''
          [global]
          debug log = syslog
          access log = syslog
          error log = syslog
        '';
      };

      python = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Whether to enable python-based plugins
          '';
        };
        extraPackages = mkOption {
          type = types.functionTo (types.listOf types.package);
          default = ps: [];
          defaultText = literalExpression "ps: []";
          example = literalExpression ''
            ps: [
              ps.psycopg2
              ps.docker
              ps.dnspython
            ]
          '';
          description = lib.mdDoc ''
            Extra python packages available at runtime
            to enable additional python plugins.
          '';
        };
      };

      extraPluginPaths = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = literalExpression ''
          [ "/path/to/plugins.d" ]
        '';
        description = lib.mdDoc ''
          Extra paths to add to the netdata global "plugins directory"
          option.  Useful for when you want to include your own
          collection scripts.

          Details about writing a custom netdata plugin are available at:
          <https://docs.netdata.cloud/collectors/plugins.d/>

          Cannot be combined with configText.
        '';
      };

      config = mkOption {
        type = types.attrsOf types.attrs;
        default = {};
        description = lib.mdDoc "netdata.conf configuration as nix attributes. cannot be combined with configText.";
        example = literalExpression ''
          global = {
            "debug log" = "syslog";
            "access log" = "syslog";
            "error log" = "syslog";
          };
        '';
      };

      configDir = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = lib.mdDoc ''
          Complete netdata config directory except netdata.conf.
          The default configuration is merged with changes
          defined in this option.
          Each top-level attribute denotes a path in the configuration
          directory as in environment.etc.
          Its value is the absolute path and must be readable by netdata.
          Cannot be combined with configText.
        '';
        example = literalExpression ''
          "health_alarm_notify.conf" = pkgs.writeText "health_alarm_notify.conf" '''
            sendmail="/path/to/sendmail"
          ''';
          "health.d" = "/run/secrets/netdata/health.d";
        '';
      };

      claimTokenFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          If set, automatically registers the agent using the given claim token
          file.
        '';
      };

      enableAnalyticsReporting = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable reporting of anonymous usage statistics to Netdata Inc. via either
          Google Analytics (in versions prior to 1.29.4), or Netdata Inc.'s
          self-hosted PostHog (in versions 1.29.4 and later).
          See: <https://learn.netdata.cloud/docs/agent/anonymous-statistics>
        '';
      };

      deadlineBeforeStopSec = mkOption {
        type = types.int;
        default = 120;
        description = lib.mdDoc ''
          In order to detect when netdata is misbehaving, we run a concurrent task pinging netdata (wait-for-netdata-up)
          in the systemd unit.

          If after a while, this task does not succeed, we stop the unit and mark it as failed.

          You can control this deadline in seconds with this option, it's useful to bump it
          if you have (1) a lot of data (2) doing upgrades (3) have low IOPS/throughput.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      [ { assertion = cfg.config != {} -> cfg.configText == null ;
          message = "Cannot specify both config and configText";
        }
      ];

    services.netdata.configDir.".opt-out-from-anonymous-statistics" = mkIf (!cfg.enableAnalyticsReporting) (pkgs.writeText ".opt-out-from-anonymous-statistics" "");
    environment.etc."netdata/netdata.conf".source = configFile;
    environment.etc."netdata/conf.d".source = configDirectory;

    systemd.services.netdata = {
      description = "Real time performance monitoring";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = (with pkgs; [ curl gawk iproute2 which procps bash ])
        ++ lib.optional cfg.python.enable (pkgs.python3.withPackages cfg.python.extraPackages)
        ++ lib.optional config.virtualisation.libvirtd.enable (config.virtualisation.libvirtd.package);
      environment = {
        PYTHONPATH = "${cfg.package}/libexec/netdata/python.d/python_modules";
        NETDATA_PIPENAME = "/run/netdata/ipc";
      } // lib.optionalAttrs (!cfg.enableAnalyticsReporting) {
        DO_NOT_TRACK = "1";
      };
      restartTriggers = [
        config.environment.etc."netdata/netdata.conf".source
        config.environment.etc."netdata/conf.d".source
      ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/netdata -P /run/netdata/netdata.pid -D -c /etc/netdata/netdata.conf";
        ExecReload = "${pkgs.util-linux}/bin/kill -s HUP -s USR1 -s USR2 $MAINPID";
        ExecStartPost = pkgs.writeShellScript "wait-for-netdata-up" ''
          while [ "$(${cfg.package}/bin/netdatacli ping)" != pong ]; do sleep 0.5; done
        '';

        TimeoutStopSec = cfg.deadlineBeforeStopSec;
        Restart = "on-failure";
        # User and group
        User = cfg.user;
        Group = cfg.group;
        # Performance
        LimitNOFILE = "30000";
        # Runtime directory and mode
        RuntimeDirectory = "netdata";
        RuntimeDirectoryMode = "0750";
        # State directory and mode
        StateDirectory = "netdata";
        StateDirectoryMode = "0750";
        # Cache directory and mode
        CacheDirectory = "netdata";
        CacheDirectoryMode = "0750";
        # Logs directory and mode
        LogsDirectory = "netdata";
        LogsDirectoryMode = "0750";
        # Configuration directory and mode
        ConfigurationDirectory = "netdata";
        ConfigurationDirectoryMode = "0755";
        # Capabilities
        CapabilityBoundingSet = [
          "CAP_DAC_OVERRIDE"      # is required for freeipmi and slabinfo plugins
          "CAP_DAC_READ_SEARCH"   # is required for apps and systemd-journal plugin
          "CAP_FOWNER"            # is required for freeipmi plugin
          "CAP_SETPCAP"           # is required for apps, perf and slabinfo plugins
          "CAP_SYS_ADMIN"         # is required for perf plugin
          "CAP_SYS_PTRACE"        # is required for apps plugin
          "CAP_SYS_RESOURCE"      # is required for ebpf plugin
          "CAP_NET_RAW"           # is required for fping app
          "CAP_SYS_CHROOT"        # is required for cgroups plugin
          "CAP_SETUID"            # is required for cgroups and cgroups-network plugins
          "CAP_SYSLOG"            # is required for systemd-journal plugin
        ];
        # Sandboxing
        ProtectSystem = "full";
        ProtectHome = "read-only";
        PrivateTmp = true;
        ProtectControlGroups = true;
        PrivateMounts = true;
      } // (lib.optionalAttrs (cfg.claimTokenFile != null) {
        LoadCredential = [
          "netdata_claim_token:${cfg.claimTokenFile}"
        ];

        ExecStartPre = pkgs.writeShellScript "netdata-claim" ''
          set -euo pipefail

          if [[ -f /var/lib/netdata/cloud.d/claimed_id ]]; then
            # Already registered
            exit
          fi

          exec ${cfg.package}/bin/netdata-claim.sh \
            -token="$(< "$CREDENTIALS_DIRECTORY/netdata_claim_token")" \
            -url=https://app.netdata.cloud \
            -daemon-not-running
        '';
      });
    };

    systemd.enableCgroupAccounting = true;

    security.wrappers = {
      "apps.plugin" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/apps.plugin.org";
        capabilities = "cap_dac_read_search,cap_sys_ptrace+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };

      "cgroup-network" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/cgroup-network.org";
        capabilities = "cap_setuid+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };

      "perf.plugin" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/perf.plugin.org";
        capabilities = "cap_sys_admin+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };

      "systemd-journal.plugin" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/systemd-journal.plugin.org";
        capabilities = "cap_dac_read_search,cap_syslog+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };

      "slabinfo.plugin" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/slabinfo.plugin.org";
        capabilities = "cap_dac_override+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };

    } // optionalAttrs (cfg.package.withIpmi) {
      "freeipmi.plugin" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/freeipmi.plugin.org";
        capabilities = "cap_dac_override,cap_fowner+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };
    };

    security.pam.loginLimits = [
      { domain = "netdata"; type = "soft"; item = "nofile"; value = "10000"; }
      { domain = "netdata"; type = "hard"; item = "nofile"; value = "30000"; }
    ];

    users.users = optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} = {
        group = defaultUser;
        isSystemUser = true;
      };
    };

    users.groups = optionalAttrs (cfg.group == defaultUser) {
      ${defaultUser} = { };
    };

  };
}
