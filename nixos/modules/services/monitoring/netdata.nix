{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.netdata;

  wrappedPlugins = pkgs.runCommand "wrapped-plugins" { preferLocalBuild = true; } ''
    mkdir -p $out/libexec/netdata/plugins.d
    ln -s /run/wrappers/bin/apps.plugin $out/libexec/netdata/plugins.d/apps.plugin
    ln -s /run/wrappers/bin/freeipmi.plugin $out/libexec/netdata/plugins.d/freeipmi.plugin
    ln -s /run/wrappers/bin/perf.plugin $out/libexec/netdata/plugins.d/perf.plugin
    ln -s /run/wrappers/bin/slabinfo.plugin $out/libexec/netdata/plugins.d/slabinfo.plugin
  '';

  plugins = [
    "${cfg.package}/libexec/netdata/plugins.d"
    "${wrappedPlugins}/libexec/netdata/plugins.d"
  ] ++ cfg.extraPluginPaths;

  localConfig = {
    global = {
      "plugins directory" = concatStringsSep " " plugins;
    };
    web = {
      "web files owner" = "root";
      "web files group" = "root";
    };
  };
  mkConfig = generators.toINI {} (recursiveUpdate localConfig cfg.config);
  configFile = pkgs.writeText "netdata.conf" (if cfg.configText != null then cfg.configText else mkConfig);

  defaultUser = "netdata";

in {
  options = {
    services.netdata = {
      enable = mkEnableOption "netdata";

      package = mkOption {
        type = types.package;
        default = pkgs.netdata;
        defaultText = "pkgs.netdata";
        description = "Netdata package to use.";
      };

      user = mkOption {
        type = types.str;
        default = "netdata";
        description = "User account under which netdata runs.";
      };

      group = mkOption {
        type = types.str;
        default = "netdata";
        description = "Group under which netdata runs.";
      };

      configText = mkOption {
        type = types.nullOr types.lines;
        description = "Verbatim netdata.conf, cannot be combined with config.";
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
          description = ''
            Whether to enable python-based plugins
          '';
        };
        extraPackages = mkOption {
          type = types.functionTo (types.listOf types.package);
          default = ps: [];
          defaultText = "ps: []";
          example = literalExample ''
            ps: [
              ps.psycopg2
              ps.docker
              ps.dnspython
            ]
          '';
          description = ''
            Extra python packages available at runtime
            to enable additional python plugins.
          '';
        };
      };

      extraPluginPaths = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = literalExample ''
          [ "/path/to/plugins.d" ]
        '';
        description = ''
          Extra paths to add to the netdata global "plugins directory"
          option.  Useful for when you want to include your own
          collection scripts.
          </para><para>
          Details about writing a custom netdata plugin are available at:
          <link xlink:href="https://docs.netdata.cloud/collectors/plugins.d/"/>
          </para><para>
          Cannot be combined with configText.
        '';
      };

      config = mkOption {
        type = types.attrsOf types.attrs;
        default = {};
        description = "netdata.conf configuration as nix attributes. cannot be combined with configText.";
        example = literalExample ''
          global = {
            "debug log" = "syslog";
            "access log" = "syslog";
            "error log" = "syslog";
          };
        '';
      };

      enableAnalyticsReporting = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable reporting of anonymous usage statistics to Netdata Inc. via either
          Google Analytics (in versions prior to 1.29.4), or Netdata Inc.'s
          self-hosted PostHog (in versions 1.29.4 and later).
          See: <link xlink:href="https://learn.netdata.cloud/docs/agent/anonymous-statistics"/>
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

    systemd.services.netdata = {
      description = "Real time performance monitoring";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = (with pkgs; [ curl gawk which ]) ++ lib.optional cfg.python.enable
        (pkgs.python3.withPackages cfg.python.extraPackages);
      environment = {
        PYTHONPATH = "${cfg.package}/libexec/netdata/python.d/python_modules";
      } // lib.optionalAttrs (!cfg.enableAnalyticsReporting) {
        DO_NOT_TRACK = "1";
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/netdata -P /run/netdata/netdata.pid -D -c ${configFile}";
        ExecReload = "${pkgs.util-linux}/bin/kill -s HUP -s USR1 -s USR2 $MAINPID";
        TimeoutStopSec = 60;
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
          "CAP_DAC_READ_SEARCH"   # is required for apps plugin
          "CAP_FOWNER"            # is required for freeipmi plugin
          "CAP_SETPCAP"           # is required for apps, perf and slabinfo plugins
          "CAP_SYS_ADMIN"         # is required for perf plugin
          "CAP_SYS_PTRACE"        # is required for apps plugin
          "CAP_SYS_RESOURCE"      # is required for ebpf plugin
          "CAP_NET_RAW"           # is required for fping app
        ];
        # Sandboxing
        ProtectSystem = "full";
        ProtectHome = "read-only";
        PrivateTmp = true;
        ProtectControlGroups = true;
        PrivateMounts = true;
      };
    };

    systemd.enableCgroupAccounting = true;

    security.wrappers."apps.plugin" = {
      source = "${cfg.package}/libexec/netdata/plugins.d/apps.plugin.org";
      capabilities = "cap_dac_read_search,cap_sys_ptrace+ep";
      owner = cfg.user;
      group = cfg.group;
      permissions = "u+rx,g+rx,o-rwx";
    };

    security.wrappers."freeipmi.plugin" = {
      source = "${cfg.package}/libexec/netdata/plugins.d/freeipmi.plugin.org";
      capabilities = "cap_dac_override,cap_fowner+ep";
      owner = cfg.user;
      group = cfg.group;
      permissions = "u+rx,g+rx,o-rwx";
    };

    security.wrappers."perf.plugin" = {
      source = "${cfg.package}/libexec/netdata/plugins.d/perf.plugin.org";
      capabilities = "cap_sys_admin+ep";
      owner = cfg.user;
      group = cfg.group;
      permissions = "u+rx,g+rx,o-rx";
    };

    security.wrappers."slabinfo.plugin" = {
      source = "${cfg.package}/libexec/netdata/plugins.d/slabinfo.plugin.org";
      capabilities = "cap_dac_override+ep";
      owner = cfg.user;
      group = cfg.group;
      permissions = "u+rx,g+rx,o-rx";
    };

    security.pam.loginLimits = [
      { domain = "netdata"; type = "soft"; item = "nofile"; value = "10000"; }
      { domain = "netdata"; type = "hard"; item = "nofile"; value = "30000"; }
    ];

    users.users = optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} = {
        isSystemUser = true;
      };
    };

    users.groups = optionalAttrs (cfg.group == defaultUser) {
      ${defaultUser} = { };
    };

  };
}
